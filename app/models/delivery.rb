class Delivery < ApplicationRecord
  include AASM
  belongs_to :order_account

  def update_delivery_state(event_name)
    case event_name
    when "new" then self.declare_new!
    when "printed" then self.declare_printed!
    when "sended" then self.declare_sended!
    end
  end

  aasm do
    state :before_send, initial: true

    state :new, :printed, :sended

    event :declare_new do
      transitions to: :new
    end

    event :declare_printed do
      transitions to: :printed
    end

    event :declare_sended do
      transitions to: :sended
    end
  end
end
