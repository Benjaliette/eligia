class OrderAccount < ApplicationRecord
  after_save :update_order_state

  include AASM

  belongs_to :order
  belongs_to :account
  has_many :notifications, dependent: :destroy

  has_one_attached :resiliation_file

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  scope :document_missing,      ->{ where(aasm_state: 'document_missing') }
  scope :pending,      ->{ where(aasm_state: 'pending') }
  scope :resiliation_sent,   ->{ where(aasm_state: 'resiliation_sent') }
  scope :resiliation_failure,         ->{ where(aasm_state: 'resiliation_failure') }
  scope :resiliation_success,   ->{ where(aasm_state: 'resiliation_success') }

  rails_admin do
    configure :aasm_state do
      read_only true
    end
    list do
      scopes ['document_missing', 'pending', 'resiliation_sent', 'resiliation_failure', 'resiliation_success']
    end
  end

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

  def update_state
    # Nom assez mal choisi pour l'instant vu qu'on fait juste un update vers pending.
    return unless self.order_documents.all? { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) } && self.document_missing?

      self.declare_pending!
  end

  def rename_resiliation_file
    return unless self.resiliation_file.attached?

    bucket_name = "eligia_cloud_storage"
    file_name = self.resiliation_file.blob.key
    order_name = "#{self.order.deceased_first_name}_#{self.order.deceased_last_name}"
    new_name = "#{order_name}/#{self.account.name}/#{self.updated_at.strftime('%y%m%d')}_Résiliation_#{self.account.name.gsub(' ', '_')}.#{self.resiliation_file.filename.extension}"

    storage = Google::Cloud::Storage.new
    bucket  = storage.bucket bucket_name, skip_lookup: true
    file = bucket.file file_name
    renamed_file = file.copy new_name

    self.resiliation_file.update(key: renamed_file.name)

    file.delete
  end

  def create_resiliation_file
    pdf = OrderAccountPdf.new(self)
    pdf.resiliation_pdf
    pdf.build_and_upload
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
      transitions from: :document_missing, to: :pending, after: Proc.new { create_resiliation_file }
    end

    event :declare_resiliation_sent do
      transitions from: :pending, to: :resiliation_sent, after: Proc.new { notify_resiliation_send }
    end

    event :declare_resiliation_success do
      transitions from: :resiliation_sent, to: :resiliation_success, after: Proc.new { notify_resiliation_success }
    end

    event :declare_resiliation_failure do
      transitions from: %i[document_missing pending resiliation_sent], to: :resiliation_failure
    end
  end

  def notify_resiliation_send
    Notification.create(
      content: "Demande de résiliation du contrat #{self.account.name} de #{self.order.deceased_first_name} #{self.order.deceased_last_name} envoyée",
      order: self.order
    )
  end

  def notify_resiliation_success
    Notification.create(
      content: "Contrat '#{self.account.name}' de #{self.order.deceased_first_name} #{self.order.deceased_last_name} résilié",
      order: self.order
    )
  end
end
