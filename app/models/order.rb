class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :pack
  belongs_to :user
  has_many :order_accounts, dependent: :destroy
  has_many :order_documents, dependent: :destroy

  validates :deceased_first_name, :deceased_last_name,
            presence: true,
            format: { with: /\A\D+\z/, message: "ne doit contenir que des lettres" }

  accepts_nested_attributes_for :order_accounts, allow_destroy: true
  accepts_nested_attributes_for :order_documents, allow_destroy: true

  def required_documents
    # Le but de cette méthode est de lister les documents nécessaires pour une order donnée.
    # --> En sortie on a un array d'instances de documents
    required_documents = []
    self.order_accounts.each do |o_a|
      required_documents << o_a.account.account_documents.map(&:document)
    end
    required_documents.flatten.uniq
  end

  def every_document_created?
    # Retourne true si tous les documents nécessaires ont été créés, false autrement.
    created = []
    self.required_documents.each do |required_document|
      created << self.order_documents.map(&:document_id).include?(required_document.id)
    end
    created.uniq == [true]
  end

  def which_document_created?
    # Cette méthode retourne un array d'arrays.
    # Chaque ligne est un array composé du nom du document et de true/false si il a été créé. ex :
    # [['Certificat de décès', true], ['Carte identité', false]]
    created = []
    self.required_documents.each do |required_document|
      created << [required_document.name, self.order_documents.map(&:document_id).include?(required_document.id)]
    end
    created
  end

  def has_this_created?(document)
    self.order_documents.map(&:document_id).include?(document.id)
  end

  def reject_order_document(attributes)
    attributes[:order][:order_document][:document_file].blank?
  end
end
