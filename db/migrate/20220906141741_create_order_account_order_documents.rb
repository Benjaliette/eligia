class CreateOrderAccountOrderDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :order_account_order_documents do |t|
      t.references :order_account, null: false, foreign_key: true
      t.references :order_document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
