class AddAasmStateToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :aasm_state, :string
  end
end
