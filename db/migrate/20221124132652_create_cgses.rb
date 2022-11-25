class CreateCgses < ActiveRecord::Migration[7.0]
  def change
    create_table :cgses do |t|
      t.text :text

      t.timestamps
    end
  end
end
