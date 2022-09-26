class Notification < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :order_account, optional: true
end
