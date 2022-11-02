class OrderDocument < ApplicationRecord
  include ActiveStoragePath

  has_one_attached :document_file
  has_one_attached_with :document_file, path: -> { "#{self.order.deceased_first_name}_#{self.order.deceased_last_name}" }
  belongs_to :document
  belongs_to :order

  validates :document_input, file_type: true

  def pdf?
    return false unless self.document_file.attached?

    self.document_file.blob.content_type == 'application/pdf'
  end

  def document_entered?
    if self.document.format == "file"
      self.document_file.attached?
    else
      self.document_input != ""
    end
  end
end
