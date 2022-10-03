Rails.application.config.after_initialize do
  require 'active_storage/attachment'

  class ActiveStorage::Attachment
    after_create_commit :callbacks

    def callbacks
      return unless record_type == "OrderDocument"
      
      
      record.order.order_accounts.each do |order_account|
        if order_account.required_documents.include?(record.document) && order_account.resiliation_file.attached?
          order_account.create_resiliation_file
        end
      end
    end
  end
end
