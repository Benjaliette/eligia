class AddSlugToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :slug, :string
    add_index :orders, :slug, unique: true
  end
end
