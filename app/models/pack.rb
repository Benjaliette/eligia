class Pack < ApplicationRecord
  monetize :price_cents

  has_many :orders
end
