class AddPacksAndPaiementPropertyToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :pack, foreign_key: true
    add_monetize :orders, :amount, currency: { present: false }
    add_column :orders, :checkout_session_id, :string
  end
end
