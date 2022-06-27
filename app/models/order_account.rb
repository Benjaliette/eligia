class OrderAccount < ApplicationRecord
  belongs_to :order
  belongs_to :account
end
