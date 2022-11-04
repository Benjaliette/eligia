require 'rails_helper'

RSpec.describe Address, type: :model do
  context "Validation" do

    it "Should be invalid when missing street" do
      address = build(:address, street: nil)
      expect(address.valid?).to eq false
    end

    it "Should be invalid when missing city" do
      address = build(:address, city: nil)
      expect(address.valid?).to eq false
    end

    it "Should be invalid when missing zip" do
      address = build(:address, zip: nil)
      expect(address.valid?).to eq false
    end

    it "Should be invalid when missing state" do
      address = build(:address, state: nil)
      expect(address.valid?).to eq false
    end

    it "Order invalid if address is invalid" do
      order = build(:order)
      expect { create(:address, street: nil, order:) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "Order should be valid with a valid address" do
      order = build(:order)
      build(:address, order:)
      expect(order.valid?).to eq true
    end
  end
end
