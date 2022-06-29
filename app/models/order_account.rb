class OrderAccount < ApplicationRecord
  belongs_to :order
  belongs_to :account

  accepts_nested_attributes_for :account, allow_destroy: true
end
