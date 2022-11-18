class Delivery < ApplicationRecord
  include AASM
  belongs_to :order_account

  def update_delivery_state(event_name)
    case event_name
    when "new" then self.declare_new!
    when "printed" then self.declare_printed!
    when "sended" then self.declare_sended!
    when "delivered" then self.declare_delivered!
    when "error" then self.declare_error!
    end
  end

  aasm do
    state :before_send, initial: true

    state :new, :printed, :sended, :delivered, :error, :avis_reception_elec, :preuve_depot_dispo

    event :declare_new do
      transitions to: :new
    end

    event :declare_printed do
      transitions to: :printed
    end

    event :declare_sended do
      transitions to: :sended
    end

    event :declare_delivered do
      transitions to: :delivered
    end

    event :declare_error do
      transitions to: :error
    end

    event :declare_avis_reception_elec do
      transitions to: :avis_reception_elec
    end

    event :declare_preuve_depot_dispo do
      transitions to: :preuve_depot_dispo
    end
  end
end
