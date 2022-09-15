class OrderAccount < ApplicationRecord
  before_save :update_order_state

  include AASM

  belongs_to :order
  belongs_to :account

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  def reject_accounts(attributes)
    attributes['name'].blank?
  end

  def required_documents
    self.account.account_documents.map(&:document)
  end

  def non_uploaded_order_documents
    o_d = self.order.order_documents.select { |order_doc| self.required_documents.include? order_doc.document }
    o_d.select do |order_document|
      (order_document.document.format == 'pdf' && !order_document.document_file.attached?) || (order_document.document.format == 'text' && order_document.document_input.blank?)
    end
  end

  def order_documents
    OrderDocument.where(order_id: self.order_id, document_id: self.required_documents)
  end

  def state_to_french
    case self.aasm_state
    when "pending" then "En traitement"
    when "document_missing" then "Document(s) manquant(s)"
    when "documents_missing" then "Document(s) manquant(s)" #Pour les commandes passées avant la modification des aasm_states
    when "resiliation_sent" then "Demande de résiliation envoyée"
    when "resiliation_failure" then "Erreur"
    when "resiliation_success" then "Compte résilié"
    when "resiliation_succeded" then "Compte résilié" #Pour les commandes passées avant la modification des aasm_states
    end
  end

  private

  def update_order_state
    self.order.update_state unless Rails.env.test?
  end

  aasm do
    state :document_missing, initial: true
    state :pending, :resiliation_sent, :resiliation_failure, :resiliation_success

    event :declare_missing do
      transitions to: :document_missing
    end

    event :declare_pending do
      transitions from: :document_missing, to: :pending
    end

    event :declare_resiliation_sent do
      transitions from: :pending, to: :resiliation_sent, after: Proc.new { notify_resiliation_send }
    end

    event :declare_resiliation_success do
      transitions from: :resiliation_sent, to: :resiliation_success, after: Proc.new { notify_resiliation_success }
    end

    event :declare_resiliation_failure do
      transitions from: %i[document_missing pending resiliation_sent], to: :resiliation_failure, after: Proc.new { notify_resiliation_failure }
    end
  end

  def notify_resiliation_send
    Notification.create(
      content: "Demande de résiliation du contrat #{self.account.name} envoyée",
      order: self.order
    )
  end

  def notify_resiliation_success
    Notification.create(
      content: "La résiliation du contrat détenu chez '#{self.account.name}' a été acceptée",
      order: self.order
    )
  end

  def notify_resiliation_failure
    Notification.create(
      content: "La résiliation du contrat détenu chez '#{self.account.name}' a été rejetée. Nous allons réessayer, si
                nous recontrons un problème lié à un document, nous vous contacterons dans les plus brefs délais",
      order: self.order
    )
  end
end
