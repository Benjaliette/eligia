class AddEnvoiIdToDeliveries < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :envoi_id, :string
  end
end
