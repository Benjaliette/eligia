class OrderDocument < ApplicationRecord
  belongs_to :document
  belongs_to :order
end
