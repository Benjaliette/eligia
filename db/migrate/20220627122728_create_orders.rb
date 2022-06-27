class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :deceased_first_name
      t.string :deceased_last_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
