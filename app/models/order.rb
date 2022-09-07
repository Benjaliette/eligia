class Order < ApplicationRecord
  include AASM

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  monetize :amount_cents

  belongs_to :pack, optional: true
  belongs_to :user, optional: true
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: { message: "Veuillez saisir ce champ" },
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "ne doit contenir que des lettres" }

  accepts_nested_attributes_for :order_documents, allow_destroy: true
  accepts_nested_attributes_for :order_accounts, allow_destroy: true, reject_if: :reject_order_accounts

  def required_documents
    required_documents = []
    self.order_accounts.each do |o_a|
      required_documents << o_a.account.account_documents.map(&:document)
    end
    required_documents.flatten.uniq
  end

  def determine_pack_type
    case self.order_accounts.size
    when 0..7 then return Pack.order(created_at: :desc).find_by(level: 1)
    when 8..15 then return Pack.order(created_at: :desc).find_by(level: 2)
    else return Pack.order(created_at: :desc).find_by(level: 3)
    end
  end

  def update_state
    return unless (self.order_accounts.all? { |order_account| order_account.aasm_state == 'resiliation_succeded' }) && (self.aasm_state == 'resiliation_sent')

    self.declare_done!
  end

  def state_to_french
    case self.aasm_state
    when "pending" then "En cours de traitement"
    when "done" then "Tous les contrats ont été traités"
    end
  end

  def set_stripe_paiement(success_url, cancel_url)
    customer = set_stripe_customer
    product = set_stripe_product
    price = set_stripe_price(product)

    Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      billing_address_collection: 'required',
      line_items: [{
        price: price.id,
        quantity: 1,
      }],
      customer: customer,
      mode: 'payment',
      success_url: "#{success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url
    )
  end

  def clear_order_accounts(order_params)
    old_oa = self.order_accounts.map(&:account).map(&:id)
    new_oa = order_params[:order_accounts_attributes].values.reject { |value| value[:account_id].blank? }.map { |value| value[:account_id].to_i }
    self.update(order_params)

    unless (old_oa - new_oa).empty?
      (old_oa - new_oa).each do |oa|
        self.order_accounts.find_by(account_id: oa).delete
        self.reload
      end
    end
  end

  def generate_order_documents
    self.order_documents.map(&:delete) unless self.order_documents.empty?
    self.reload
    self.required_documents.each do |required_document|
      OrderDocument.create(order: self, document: required_document) unless self.order_documents.any? { |order_document| (order_document.document == required_document) }
    end
  end

  def update_order_account_status
    return unless self.aasm_state == 'document_missing'

    self.order_accounts.each do |order_account|
      order_account.declare_pending! if order_account.order_documents.all? { |order_document| (order_document.document_file.attached? || order_document.document_input.present?)}
    end
  end

  def jsonify_order_accounts
    accounts = self.order_accounts.map do |order_account|
      {
        account_id: order_account.account.id,
        account_valid: order_account.account.status,
        account_name: order_account.account.name.gsub(' ', '_'),
        account_subcategory: order_account.account.subcategory.id
      }
    end

    JSON.generate({ accounts: })
  end

  def jsonify_order_documents
    documents = self.order_documents.map do |order_document|
      {
        document: order_document.document_file.attached?
      }
    end

    JSON.generate({ documents: })
  end

  private

  def reject_order_accounts(attributes)
    # raise
    if attributes['account_id']
      attributes['account_id'].blank? || (self.order_accounts.map(&:account).map(&:id).include? attributes['account_id'].to_i)
    elsif attributes['account_attributes']
      attributes['account_attributes']['name'].blank?
    end
  end

  def slug_candidates
    [
      :deceased_last_name,
      %i[deceased_first_name deceased_last_name]
    ]
  end

  def set_stripe_customer
    Stripe::Customer.create(
      {
        email: self.user.email,
        name: "#{self.user.first_name} #{self.user.last_name}",
        metadata: { id: self.user.id }
      }
    )
  end

  def set_stripe_product
    Stripe::Product.create(
      name: "Vous souhaitez résilier #{self.order_accounts.count} comptes. \n Il s'agit donc d'une formule '#{self.pack.title}'"
    )
  end

  def set_stripe_price(product)
    Stripe::Price.create(
      {
        unit_amount: self.pack.price_cents,
        currency: 'eur',
        product: product.id
      }
    )
  end

  aasm do
    state :pending, initial: true
    state :done

    event :declare_done do
      transitions from: :pending, to: :done
    end
  end
end
