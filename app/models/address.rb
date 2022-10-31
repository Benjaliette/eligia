class Address < ApplicationRecord
  belongs_to :order

  validates :street, :zip, :city, :state, presence: { message: "doit être obligatoirement renseigné" }
end
