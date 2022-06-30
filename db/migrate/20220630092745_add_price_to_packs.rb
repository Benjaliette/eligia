class AddPriceToPacks < ActiveRecord::Migration[7.0]
  def change
    add_monetize :packs, :price, currency: { present: false }
  end
end
