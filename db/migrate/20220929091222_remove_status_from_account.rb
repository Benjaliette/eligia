class RemoveStatusFromAccount < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :status, :string
  end
end
