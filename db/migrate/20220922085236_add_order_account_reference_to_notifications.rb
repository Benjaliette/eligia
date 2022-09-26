class AddOrderAccountReferenceToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :order_account, null: true, foreign_key: true
  end
end
