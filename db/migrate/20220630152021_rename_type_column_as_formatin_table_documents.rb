class RenameTypeColumnAsFormatinTableDocuments < ActiveRecord::Migration[7.0]
  def change
    rename_column :documents, :type, :format
  end
end
