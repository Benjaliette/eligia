class ChangeCountryToCountryNameToAddresses < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :country, :string
    add_column :addresses, :state, :string
  end
end
