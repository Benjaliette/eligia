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
      address = create(:address, street: nil order:)
      expect(order.valid?).to eq false
    end

    it "Address errors indexed in order : order invalid if address is invalid" do
      order = build(:order)
      address =create(:address, street: nil, order: order)
      expect(order.valid?).to eq false
    end
  end
end
