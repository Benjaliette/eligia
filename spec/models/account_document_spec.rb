require 'rails_helper'

RSpec.describe AccountDocument, type: :model do
  describe "When creating an account_document" do

    it "Should be valid with an account and an document" do
      account_document = build(:account_document)
      expect(account_document.valid?).to eq true
    end

    it "Should not be valid w/o an account" do
      account_document = build(:account_document, account: nil)
      expect(account_document.valid?).to eq false
    end

    it "Should not be valid w/o an document" do
      account_document = build(:account_document, document: nil)
      expect(account_document.valid?).to eq false
    end

  end
end
