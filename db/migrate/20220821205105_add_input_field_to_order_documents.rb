class AddInputFieldToOrderDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :order_documents, :document_input, :string
  end
end
