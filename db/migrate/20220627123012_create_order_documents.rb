class CreateOrderDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :order_documents do |t|
      t.references :document, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
