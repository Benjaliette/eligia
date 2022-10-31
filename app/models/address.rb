class Address < ApplicationRecord
  belongs_to :order

  validates :street, :zip, :city, :country, presence: true
end
