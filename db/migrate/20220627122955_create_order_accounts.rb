class CreateOrderAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :order_accounts do |t|
      t.references :order, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
