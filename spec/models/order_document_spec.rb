require 'rails_helper'

RSpec.describe OrderDocument, type: :model do
  describe "When creating an order_document" do

    it "Should be valid with an order and an document" do
      order_document = build(:order_document)
      expect(order_document.valid?).to eq true
    end

    it "Should not be valid w/o an order" do
      order_document = build(:order_document, order: nil)
      expect(order_document.valid?).to eq false
    end

    it "Should not be valid w/o an document" do
      order_document = build(:order_document, document: nil)
      expect(order_document.valid?).to eq false
    end

  end
end
