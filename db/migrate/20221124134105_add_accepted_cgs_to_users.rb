class AddAcceptedCgsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :cgs, null: true, foreign_key: true
    add_column :users, :accepted_cgs, :boolean, default: false
  end
end
