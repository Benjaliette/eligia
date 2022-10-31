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

  describe "#pdf?" do
    it "Should return false if it has no document_file attached" do
      order_document = create(:order_document)
      expect(order_document.pdf?).to eq false
    end

    it "Should return false if it has a document attached that is not a pdf" do
      order_document = create(:order_document)
      order_document.document_file.attach(io: File.open(Rails.root.join('spec', 'support', 'cat_image.jpeg')), filename: 'cat_image.jpeg')
      expect(order_document.document_file.attached?).to eq true
      expect(order_document.pdf?).to eq false
    end

    it "Should return true if it has a document attached that is a pdf" do
      order_document = create(:order_document)
      order_document.document_file.attach(io: File.open(Rails.root.join('spec', 'support', 'pdf_file.pdf')), filename: 'pdf_file.pdf')
      expect(order_document.document_file.attached?).to eq true
      expect(order_document.pdf?).to eq true
    end
  end
end
