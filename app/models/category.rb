class Category < ApplicationRecord
  has_many :subcategories
  has_many :accounts
end
