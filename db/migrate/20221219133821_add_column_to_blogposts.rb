class AddColumnToBlogposts < ActiveRecord::Migration[7.0]
  def change
    add_column :blogposts, :pinned, :boolean, default: false
  end
end
