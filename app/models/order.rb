class Order < ApplicationRecord
  include AASM

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  monetize :amount_cents

  belongs_to :pack
  belongs_to :user, optional: true
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: { message: "Veuillez saisir ce champ" },
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "ne doit contenir que des lettres" }

  accepts_nested_attributes_for :order_documents, allow_destroy: true
  accepts_nested_attributes_for :order_accounts, allow_destroy: true, reject_if: :reject_order_accounts

  def required_documents
    # Le but de cette méthode est de lister les documents nécessaires pour une order donnée.
    # --> En sortie on a un array d'instances de documents
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
    return unless (self.order_accounts.all { |order_account| order_account.aasm_state == 'resiliation_succeded' } && self.aasm_state != 'done')

    self.declare_done!
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

  private

  def reject_order_accounts(attributes)
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
