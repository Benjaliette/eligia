class CreateMerciFacteurs < ActiveRecord::Migration[7.0]
  def change
    create_table :merci_facteurs do |t|
      t.string :access_token

      t.timestamps
    end
  end
end
