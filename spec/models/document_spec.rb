require 'rails_helper'

RSpec.describe Document, type: :model do
  context "When creating a document" do

    it "Should be valid with a name and a format" do
      document = build(:document)
      expect(document.valid?).to eq true
    end

    it "Should be invalid w/o a name" do
      document = build(:document, name: "")
      expect(document.valid?).to eq false
    end

    it "Should be invalid w/o a format" do
      document = build(:document, format: "")
      expect(document.valid?).to eq false
    end

    it "Should be invalid if the name is already taken" do
      create(:document, name: "id")
      document = Document.new(name: "id", format: "pdf")
      expect(document.valid?).to eq false
    end

  end
end
