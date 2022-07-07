class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :pack
  belongs_to :user
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: { message: "Veuillez saisir ce champ" },
            format: { with: /\A[a-zA-Z]+\z/, message: "ne doit contenir que des lettres" }

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

  # def determine_pack_type
  #   case self.order_accounts.size
  #   when 0..5 then return Pack.where(level: 1).last
  #   when 6..10 then return Pack.where(level: 2).last
  #   when 11..14 then return Pack.where(level: 3).last
  #   when 15..20 then return Pack.where(level: 4).last
  #   else
  #     return 'error'
  #   end
  # end

  # def determine_pack_type
  #   45
  # end

  def determine_pack_type
    last_id = Pack.last.id
    case self.order_accounts.size
    when 0..5 then return Pack.find(last_id - 3)
    when 6..10 then return Pack.find(last_id - 2)
    when 11..14 then return Pack.find(last_id - 1)
    when 15..20 then return Pack.find(last_id)
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
