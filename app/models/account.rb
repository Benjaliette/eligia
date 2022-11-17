class Account < ApplicationRecord
  include AASM

  has_many :account_documents, dependent: :destroy
  has_many :documents, through: :account_documents
  has_many :order_accounts, dependent: :destroy
  belongs_to :subcategory
  has_one :address, dependent: :destroy

  validates :name, presence: true
  validates_associated :address

  scope :validated,      ->{ where(aasm_state: 'validated') }
  scope :non_validated,  ->{ where(aasm_state: 'non_validated') }

  rails_admin do
    configure :aasm_state do
      read_only true
    end
    list do
      scopes ['validated', 'non_validated']
    end
  end

  def self.validated_accounts_from_subcategory(subcategory)
    return where(aasm_state: 'validated', subcategory: subcategory)
  end

  aasm do
    state :non_validated, initial: true
    state :validated

    event :declare_validated do
      transitions from: :non_validated, to: :validated, after: proc { notify_validated }
    end
  end

  def notify_validated
    Notification.create(
      content: "Le contrat '#{self.name}' a été validé. Vous pouvez retrouver les documents à y joindre en cliquant
                sur cette notification",
      order: self.order_accounts.first.order,
      order_account: self.order_accounts.first
    )
  end
end
