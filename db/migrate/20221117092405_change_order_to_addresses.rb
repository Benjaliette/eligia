class ChangeOrderToAddresses < ActiveRecord::Migration[7.0]
  def change
    change_column_null :addresses, :order_id, true
  end
end
