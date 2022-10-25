class AddModalToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :need_modal, :boolean, default: false
    add_column :accounts, :modal_content, :text
  end
end
