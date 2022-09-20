class OrderDocument < ApplicationRecord
  has_one_attached :document_file

  belongs_to :document
  belongs_to :order

  def move_file
    require "google/cloud/storage"

    if self.document_file.attached?
      bucket_name = "eligia_cloud_storage"
      file_name = self.document_file.blob.key
      order_name = "#{self.order.deceased_first_name}_#{self.order.deceased_last_name}"
      new_name = "#{order_name}/#{self.order.created_at.strftime('%y%m%d')}_#{self.document.name.gsub(' ', '_')}.#{self.document_file.filename.extension}"

      storage = Google::Cloud::Storage.new
      bucket  = storage.bucket bucket_name, skip_lookup: true
      file    = bucket.file file_name

      renamed_file = file.copy new_name

      file.delete
    end
  end
end
