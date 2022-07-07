class Pack < ApplicationRecord
  monetize :price_cents

  has_many :orders
  validates :title, presence: true, uniqueness: true
  validates :price_cents, presence: true
  validates :level, presence: true
end
