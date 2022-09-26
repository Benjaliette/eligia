class ChangeNullOrderFromOrderAccount < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:order_accounts, :order_id, true)
  end
end
