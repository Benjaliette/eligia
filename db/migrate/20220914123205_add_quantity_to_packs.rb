class AddQuantityToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :quantity_text, :string
  end
end
