class AddBoolToOrderAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :order_accounts, :bool, :boolean
  end
end
