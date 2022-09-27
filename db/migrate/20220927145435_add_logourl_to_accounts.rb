class AddLogourlToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :logo_url, :string
  end
end
