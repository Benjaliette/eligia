class Account < ApplicationRecord
  include AASM

  has_many :account_documents, dependent: :destroy
  has_many :documents, through: :account_documents
  has_many :order_accounts, dependent: :destroy
  belongs_to :subcategory

  validates :name, presence: true #, uniqueness: { scope: :subcategory }

  scope :validated,      ->{ where(aasm_state: 'validated') }
  scope :non_validated,   ->{ where(aasm_state: 'non_validated') }

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

    event :validate do
      transitions from: :non_validated, to: :validated
    end
  end
end
