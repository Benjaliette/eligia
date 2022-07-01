class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :accounts, dependent: :destroy
end
