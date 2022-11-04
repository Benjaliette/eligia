require 'rails_helper'

RSpec.describe Address, type: :model do
  context "When start a payment" do
    it "Should be valid when entering all values" do
      order = build(:order)
      address = build(:address, order: order)
      expect(order.valid?).to eq true
    end

    it "Should be invalid w/o a street name" do
      order = build(:order)
      address = Address.create(zip: '33000', city: "Bordeaux", state: "France", order: order)
      expect(order.valid?).to eq false
    end

    it "Should be invalid when empty" do
      order = build(:order)
      address = Address.create(order: order)
      expect(order.valid?).to eq false
    end
  end
end
