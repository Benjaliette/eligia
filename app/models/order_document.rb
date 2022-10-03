class OrderDocument < ApplicationRecord
  require "google/cloud/storage"
  include ActiveStoragePath

  has_one_attached :document_file
  has_one_attached_with :document_file, path: -> { "#{self.order.deceased_first_name}_#{self.order.deceased_last_name}" }
  belongs_to :document
  belongs_to :order

  validates :document_input, file_type: true

  def pdf?
    return unless self.document_file.attached?

    self.document_file.blob.content_type == 'application/pdf'
  end

  def rename_document_file
    if self.document_file.attached?
      bucket_name = "eligia_cloud_storage"
      file_name = self.document_file.blob.key
      order_name = "#{self.order.deceased_first_name}_#{self.order.deceased_last_name}"
      new_name = "#{order_name}/#{self.order.created_at.strftime('%y%m%d')}_#{self.document.name.gsub(' ', '_')}.#{self.document_file.filename.extension}"

      storage = Google::Cloud::Storage.new
      bucket  = storage.bucket bucket_name, skip_lookup: true
      file    = bucket.file file_name

      renamed_file = file.copy new_name

      self.document_file.update(key: renamed_file.name)

      file.delete
    end
  end
end
