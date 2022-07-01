class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :user
  has_many :order_accounts
  has_many :order_documents
  belongs_to :pack

  validates :deceased_first_name, :deceased_last_name,
            presence: true,
            format: { with: /\A\D+\z/, message: "ne doit contenir que des lettres" }

  accepts_nested_attributes_for :order_accounts, allow_destroy: true

  def required_documents
    required_documents = []
    self.order_accounts.each do |o_a|
      required_documents << o_a.account.account_documents.map(&:document)
    end
    required_documents.flatten.uniq
  end

  def every_document_uploaded?
    uploads = []
    self.required_documents.each do |required_document|
      uploads << self.order_documents.map(&:document_id).include?(required_document.id)
    end
    uploads.exclude?(false)
  end

  def which_document_uploaded?
    uploads = []
    self.required_documents.each do |required_document|
      uploads << [required_document.name, self.order_documents.map(&:document_id).include?(required_document.id)]
    end
    uploads
  end
end
