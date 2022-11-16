class OrderAccount < ApplicationRecord
  require 'json'
  require 'cgi'
  include AASM
  include ActiveStoragePath

  after_save :update_order_state

  belongs_to :order
  belongs_to :account
  has_many :notifications, dependent: :destroy

  has_one_attached_with :resiliation_file, path: -> { self.set_attached_with_path }

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  scope :document_missing, -> { where(aasm_state: 'document_missing') }
  scope :pending, -> { where(aasm_state: 'pending') }
  scope :resiliation_sent, -> { where(aasm_state: 'resiliation_sent') }
  scope :resiliation_failure, -> { where(aasm_state: 'resiliation_failure') }
  scope :resiliation_success, -> { where(aasm_state: 'resiliation_success') }

  rails_admin do
    configure :aasm_state do
      read_only true
    end
    list do
      scopes ['document_missing', 'pending', 'resiliation_sent', 'resiliation_failure', 'resiliation_success']
    end
  end

  STATES = ["document_missing", "pending", "resiliation_sent", "resiliation_failure", "resiliation_success"]

  def reject_accounts(attributes)
    attributes['name'].blank?
  end

  def required_documents
    self.account.account_documents.map(&:document)
  end

  def non_uploaded_order_documents
    self.order_documents.select do |order_document|
      (order_document.document.format == 'file' && !order_document.document_file.attached?) || (order_document.document.format == 'text' && order_document.document_input.blank?)
    end
  end

  def order_documents
    OrderDocument.where(order_id: self.order_id, document_id: self.required_documents)
  end

  def state_to_french(state = self.aasm_state)
    case state
    when "pending" then "En traitement"
    when "document_missing", "documents_missing" then "Document(s) manquant(s)"
    when "resiliation_sent" then "Demande de résiliation envoyée"
    when "resiliation_failure" then "Erreur"
    when "resiliation_success", "resiliation_succeded" then "Compte résilié"
    end
  end

  def update_state
    # Nom assez mal choisi pour l'instant vu qu'on fait juste un update vers pending.
    return unless self.order_documents.all? { |order_document| (order_document.document_file.attached? || order_document.document_input.present?) } && self.document_missing? &&  self.account.validated?

      self.declare_pending!
  end

  def generate_resiliation_file
    OrderAccountPdf.new(self).build_and_upload_resiliation
  end

  def current_state_index
    state_index(self.aasm_state)
  end

  def passed_state?(state)
    current_state_index >= state_index(state)
  end

  def link_related_files
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket self.find_bucket, skip_lookup: true
    file_links = []
    bucket.files.each do |file|
      account_name = self.account.name.gsub(/[ ()]/, ' ' => '_', '(' => '\(', ')' => '\)')
      regex = /\A#{self.order.deceased_first_name.gsub(' ', '_')}_#{self.order.deceased_last_name.gsub(' ', '_')}\/#{account_name}\/justificatifs\/.+/
      if regex.match(file.name)
        file_links << { signed_url: file.signed_url, file_name: file.name.match(/justificatifs\/(.+)/)[1] }
      end
    end
    file_links
  end

  # private

  def update_order_state
    self.order.update_state unless Rails.env.test?
  end

  def state_index(state)
    STATES.index(state)
  end

  aasm do
    state :document_missing, initial: true
    state :pending, :resiliation_sent, :resiliation_failure, :resiliation_success

    event :declare_missing do
      transitions to: :document_missing
    end

    event :declare_pending do
      transitions from: :document_missing, to: :pending, after: proc { generate_resiliation_file }
    end

    event :declare_resiliation_sent do
      transitions from: :pending,
                  to: :resiliation_sent,
                  after: proc {
                    notify_resiliation_send
                    self.send_resiliation unless Rails.env == 'test'
                  }
    end

    event :declare_resiliation_success do
      transitions from: :resiliation_sent, to: :resiliation_success, after: proc { notify_resiliation_success }
    end

    event :declare_resiliation_failure do
      transitions from: %i[document_missing pending resiliation_sent], to: :resiliation_failure
    end
  end

  def notify_resiliation_send
    Notification.create(
      content: "Demande de résiliation du contrat '#{self.account.name}' de #{self.order.deceased_first_name} #{self.order.deceased_last_name} envoyée",
      order: self.order
    )
  end

  def notify_resiliation_success
    Notification.create(
      content: "Contrat '#{self.account.name}' de #{self.order.deceased_first_name} #{self.order.deceased_last_name} résilié",
      order: self.order
    )
  end

  def send_resiliation
    order_account = self
    service_id = ENV.fetch('MERCI_FACTEUR_SERVICE_ID')
    access_token = MerciFacteur.open_session.access_token

    connection = Faraday.new(
      url: 'https://www.merci-facteur.com/api/1.2/prod/service/sendCourrier',
      headers: { 'ww-service-id': service_id, 'ww-access-token': access_token }
    )

    response = connection.post do |req|
      req.body = generate_json_send_resiliation(order_account)

    end
    response = JSON.parse(response.body, symbolize_names: true)

    debugger
  end

  def generate_json_send_resiliation(order_account)
    base_64_file = Base64.encode64(URI.parse(order_account.resiliation_file.url).open.read).gsub(/\n/, "")

    json_send_resiliation = {
      idUser: 21881,
      modeEnvoi: "normal",
      adress: {
        exp: 1273844,
        dest: [
          {
            civilite: "Mme",
            nom: "Dupont",
            prenom: "Sophie",
            societe: "Dupont Corp.",
            adresse1: "9 allée de la rose",
            adresse2: "",
            adresse3: "",
            cp: "78000",
            ville: "Versailles",
            pays: "FRANCE",
            email: "",
            consent: "0",
            reference: ""
          }
        ]
      },
      content: {
        letter: {
          base64files: [
            base_64_file
          ]
        }
      }
    }
    return json_send_resiliation
  end
end
