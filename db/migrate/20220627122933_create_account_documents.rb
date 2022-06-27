class CreateAccountDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :account_documents do |t|
      t.references :account, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
