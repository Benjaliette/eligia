class AddAasmStateToDeliveries < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :aasm_state, :string
  end
end
