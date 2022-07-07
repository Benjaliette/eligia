class AddLevelToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :level, :integer, null: false
  end
end
