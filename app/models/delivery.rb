class Delivery < ApplicationRecord
  include AASM
  belongs_to :order_account

  aasm do
    state :before_send, initial: true
  end
end
