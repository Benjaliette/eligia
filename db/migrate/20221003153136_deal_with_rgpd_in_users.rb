class DealWithRgpdInUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :rgpd, null: true, foreign_key: true
    add_column :users, :accepted_rgpd, :boolean, default: false
  end
end
