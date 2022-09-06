class OrderAccountOrderDocument < ApplicationRecord
  belongs_to :order_account
  belongs_to :order_document
end
