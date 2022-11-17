class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.references :order_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
