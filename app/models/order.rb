class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :pack
  belongs_to :user
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: true,
            format: { with: /\A\D+\z/, message: "ne doit contenir que des lettres" }


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

  def every_document_attached?
    # Retourne true si tous les documents nécessaires ont été uploadés
    self.order_documents.map do |order_document|
      order_document.document_file.attached?
    end
        .uniq == [true]
  end

  def which_document_attached?
    # Chaque ligne est un array composé du nom du document et de true/false si il a été créé. ex :
    # [['Certificat de décès', true], ['Carte identité', false]]
    self.order_documents.map do |order_document|
      [order_document.document.name, order_document.document_file.attached?]
    end
  end

  def determine_pack_type
    case self.order_accounts.size
    when 1..5 then return Pack.find(1)
    when 6..10 then return Pack.find(2)
    when 10..14 then return Pack.find(3)
    when 15..20 then return Pack.find(4)
    else
      return 'error'
    end
  end

  def open_paiement_session
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: self.pack.title,
        amount: self.amount_cents,
        currency: 'eur',
        quantity: 1
      }],
      success_url: order_url(self),
      cancel_url: order_url(self)
    )

    order.update(checkout_session_id: session.id)
  end

  private

  def reject_order_accounts(attributes)
    attributes['account_id'].blank? && attributes['account_attributes']['name'].blank?
  end
end
