class OrderDocument < ApplicationRecord
  has_one_attached :document_file

  belongs_to :document
  belongs_to :order

  def pdf?
    return unless self.document_file.attached?

    self.document_file.blob.content_type == 'application/pdf'
  end
end
