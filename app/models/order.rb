class Order < ApplicationRecord
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

  private

  def reject_order_accounts(attributes)
    (attributes['account_id'].blank? && attributes['account_attributes']['name'].blank?) ||
    self.order_accounts.any? { |order_account| order_account.account.id == attributes['account_id'].to_i }
  end

  def slug_candidates
    [
      :deceased_last_name,
      %i[deceased_first_name deceased_last_name]
    ]
  end
end
