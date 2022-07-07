require 'rails_helper'

RSpec.describe Account, type: :model do

  context "When creating an account" do

    it "Should be valid when everything is provided" do
      account = build(:account)
      expect(account.valid?).to eq true
    end

    it "Should be invalid w/o a name" do
      account = build(:account, name: "")
      expect(account.valid?).to eq false
    end

    it "Should be invalid w/o a subcategory" do
      account = build(:account, subcategory: nil)
      expect(account.valid?).to eq false
    end

    it "Should be invalid if name is already taken in the same subcategory" do
      create(:account, name: "SFR", subcategory: create(:subcategory, name: "Telecom"))
      account = Account.new(name: "SFR", subcategory: Subcategory.find_by(name: "Telecom"))
      expect(account.valid?).to eq false
    end

    it "Should be valid if name is already taken in another subcategory" do
      create(:account, name: "LeMonde", subcategory: create(:subcategory, name: "Media"))
      account = Account.new(name: "LeMonde", subcategory: create(:subcategory, name: "Game"))
      expect(account.valid?).to eq true
    end
  end
end
