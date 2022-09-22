Rails.application.config.after_initialize do
  require 'active_storage/attachment'

  class ActiveStorage::Attachment
    after_create_commit :callbacks

    def callbacks
      if record_type == "OrderAccount"
        record.rename_resiliation_file
      elsif record_type == "OrderDocument"
        record.rename_document_file
      end
    end
  end
end
