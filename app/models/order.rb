class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :pack
  belongs_to :user
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: { message: "Veuillez saisir ce champ" },
            format: { with: /\A[a-zàâçéèêëîïôûùüÿñæœ'.-]*\z/i, message: "ne doit contenir que des lettres" }

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

  private

  def reject_order_accounts(attributes)
    attributes['account_id'].blank? && attributes['account_attributes']['name'].blank?
  end
end
