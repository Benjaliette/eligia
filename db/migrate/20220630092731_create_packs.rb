class CreatePacks < ActiveRecord::Migration[7.0]
  def change
    create_table :packs do |t|
      t.string :title

      t.timestamps
    end
  end
end
