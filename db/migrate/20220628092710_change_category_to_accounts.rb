class ChangeCategoryToAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :category, :string
    add_reference :accounts, :category, null: false, foreign_key: true
  end
end
