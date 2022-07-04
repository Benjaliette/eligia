class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :accounts, dependent: :destroy
end
