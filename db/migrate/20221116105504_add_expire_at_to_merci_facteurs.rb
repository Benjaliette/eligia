class AddExpireAtToMerciFacteurs < ActiveRecord::Migration[7.0]
  def change
    add_column :merci_facteurs, :expire_at, :integer
  end
end
