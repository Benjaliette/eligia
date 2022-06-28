class AddStatusToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :status, :string, null: false, default: 'non_validated'
  end
end
