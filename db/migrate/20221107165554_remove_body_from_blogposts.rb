class RemoveBodyFromBlogposts < ActiveRecord::Migration[7.0]
  def change
    remove_column :blogposts, :body, :text
  end
end
