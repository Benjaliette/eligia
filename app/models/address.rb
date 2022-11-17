class Address < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :account, optional: true

  validates :street, :zip, :city, :state, presence: { message: "doit être obligatoirement renseigné" }
end
