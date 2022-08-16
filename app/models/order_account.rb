class OrderAccount < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :account

  validates :account, uniqueness: true

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  def reject_accounts(attributes)
    attributes['name'].blank?
  end

  # Retourne les documents nécessaires à un order_account
  def required_documents
    self.account.account_documents.map(&:document)
  end

  # Retourne un array avec les instances de OrderDocument correspondant aux documents nécessaires de cet order_account
  def order_documents
    OrderDocument.where(order_id: self.order_id, document_id: self.required_documents)
  end

  # Pour avoir les states en français dans les show et utiliser les classes

  def state_to_french
    case self.aasm_state
      when "pending" then "En attente"
      when "documents_missing" then "Document(s) manquant(s)"
      when "resiliation_sent" then "Demande de résiliation envoyée"
      when "resiliation_failed" then "Erreur"
      when "resiliation_succeded" then "Compte résilié"
    end
  end

  # # State Machine
  aasm do
    state :documents_missing, initial: true
    state :pending, :resiliation_sent, :resiliation_failed, :resiliation_succeded

    event :declare_missing do
      transitions to: :documents_missing
    end

    event :declare_pending do
      transitions to: :pending
    end

    event :send_resiliation do
      transitions from: :pending, to: :resiliation_sent
    end

    event :declare_resiliation_success do
      transitions from: :resiliation_sent, to: :resiliation_succeded
    end

    event :declare_resiliation_failure do
      transitions to: :resiliation_failed
    end
  end
end
