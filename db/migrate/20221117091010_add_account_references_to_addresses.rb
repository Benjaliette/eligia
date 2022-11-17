class AddAccountReferencesToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :account, null: true, foreign_key: true
  end
end
