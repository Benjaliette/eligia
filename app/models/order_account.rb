class OrderAccount < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :account
  has_many :account_documents

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  def reject_accounts(attributes)
    attributes['name'].blank?
  end

  # State Machine
  aasm do
    state :documents_missing, :pending, :sent, :failed, :succeded

    event :declare_missing do
      transitions from: :any, to: :documents_missing
    end

    event :declare_pending do
      transitions from: :any, to: :pending
    end

    event :send do
      transitions from: :pending, to: :sent
    end

    event :declare_success do
      transitions from: :sent, to: :succeded
    end

    event :declare_failure do
      transitions from: :any, to: :failed
    end
  end
end
