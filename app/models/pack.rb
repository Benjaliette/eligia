class Pack < ApplicationRecord
  monetize :price_cents

  has_many :orders

  validates :price_cents, presence: true
end
