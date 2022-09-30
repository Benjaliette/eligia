class AddFileTypeToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :file_type, :string
  end
end
