require 'normalize_country'

class Order < ApplicationRecord
  include AASM
  include ActiveStoragePath

  after_save :check_for_change_in_paid

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  monetize :amount_cents

  belongs_to :pack, optional: true
  belongs_to :user, optional: true
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy, index_errors: true
  has_many :notifications, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one_attached_with :invoice_file, path: -> { "#{self.deceased_first_name}_#{self.deceased_last_name}" }

  accepts_nested_attributes_for :order_documents, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :deceased_first_name, :deceased_last_name,
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "ne doit contenir que des lettres" },
            presence: { message: "doit être obligatoirement renseigné" }, on: :update
  validates_associated :order_documents
  validates_associated :address, message: 'Veuillez remplir tous les champs non-optionnels'

  scope :pending,      ->{ where(aasm_state: 'pending') }
  scope :processing,   ->{ where(aasm_state: 'processing') }
  scope :done,         ->{ where(aasm_state: 'done') }

  rails_admin do
    list do
      scopes ['pending', 'processing', 'done']
    end
  end

  STATES = ['pending', 'processing', 'done']

  def required_documents
    required_documents = []
    self.order_accounts.each do |o_a|
      required_documents << o_a.account.account_documents.map(&:document)
    end
    required_documents.flatten.uniq
  end

  def determine_pack_type
    case self.order_accounts.length
    when 0..7 then return Pack.order(created_at: :desc).find_by(level: 1)
    when 8..15 then return Pack.order(created_at: :desc).find_by(level: 2)
    else return Pack.order(created_at: :desc).find_by(level: 3)
    end
  end

  def update_state
    if self.order_accounts.all? { |order_account| order_account.pending? } && self.pending?
      self.declare_processing!
    elsif self.order_accounts.all? { |order_account| order_account.resiliation_success? } && self.processing?
      self.declare_done!
    end
  end

  def state_to_french(state = self.aasm_state)
    case state
    when "pending" then "En attente d'une action de votre part"
    when "processing" then "En cours de traitement"
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

  def set_mollie_payment(success_url, webhook_url)
    customer = Mollie::Customer.create(
      name: "#{self.user.first_name} #{self.user.last_name}",
      email: self.user.email
    )

    Mollie::Payment.create(
      amount: { value: sprintf('%.2f', (self.amount_cents / 100)), currency: 'EUR' },
      description: self.pack.title,
      billingAddress: {
        streetAndNumber: self.address.street,
        postalCode: self.address.zip,
        city: self.address.city,
        country: NormalizeCountry(self.address.state, to: :alpha2)
      },
      customerId: customer.id,
      redirect_url: success_url,
      webhook_url: webhook_url
    )
  end

  def notify_order_payment
    Notification.create(
      content: "La demande de résiliation des contrats de #{self.deceased_first_name} #{self.deceased_last_name}
                a bien été prise en compte",
      order: self
    )

    doc_missing_count = self.order_documents.reject { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) }.count

    if doc_missing_count >= 1
      Notification.create(
        content: "Il vous reste des documents à fournir pour démarrer certaines résiliations (il vous manque
        #{doc_missing_count} documents).",
        order: self
      )
    end
  end

  def notify_done
    return unless self.done?

    Notification.create(
      content: "Tous les contrats de #{self.deceased_first_name} #{self.deceased_last_name} ont été résiliés.",
      order: self
    )
  end

  def generate_order_documents
    order = self
    order.order_documents.each do |order_document|
      order_document.delete unless order.required_documents.include?(order_document.document)
    end
    order.reload
    order.required_documents.each do |required_document|
      OrderDocument.create(order: order, document: required_document) unless order.order_documents.any? { |order_document| (order_document.document == required_document) }
    end
    order.reload
  end

  def non_uploaded_order_documents
    o_d = self.order_documents.select { |order_doc| self.required_documents.include? order_doc.document }
    o_d.select do |order_document|
      (order_document.document.format == 'file' && !order_document.document_file.attached?) || (order_document.document.format == 'text' && order_document.document_input.blank?)
    end
  end

  def update_order_account_status
    self.order_accounts.each { |o_a| o_a.update_state }
  end

  def jsonify_order_accounts
    accounts = self.order_accounts.map do |order_account|
      {
        account_id: order_account.account.id,
        account_valid: order_account.account.aasm_state,
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

  def current_state_index
    state_index(self.aasm_state)
  end


  def passed_state?(state)
    current_state_index >= state_index(state)
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

  def state_index(state)
    STATES.index(state)
  end

  def check_for_change_in_paid
    attach_invoice_pdf if saved_change_to_attribute?(:paid) && self.paid == true
  end

  def attach_invoice_pdf
    OrderPdf.new(self).build_and_upload_invoice
  end

  aasm do
    state :pending, initial: true
    state :processing
    state :done, after_enter: proc { notify_done }

    event :declare_processing do
      transitions from: :pending, to: :processing
    end

    event :declare_done do
      transitions from: :processing, to: :done
    end
  end
end
