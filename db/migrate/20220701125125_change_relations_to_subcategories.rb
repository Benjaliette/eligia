class ChangeRelationsToSubcategories < ActiveRecord::Migration[7.0]
  def change
    remove_reference :accounts, :category, foreign_key: true, index: false
    add_reference :accounts, :subcategory, foreign_key: true
  end
end
