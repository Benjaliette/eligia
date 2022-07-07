require 'rails_helper'

RSpec.describe Pack, type: :model do
  context "When creating a pack" do

    it "Should be valid with a title, a level and a price" do
      pack = build(:pack)
      expect(pack.valid?).to eq true
    end

    it "Should be invalid w/o a title" do
      pack = build(:pack, title: "")
      expect(pack.valid?).to eq false
    end

    it "Should be invalid w/o a level" do
      pack = build(:pack, level: "")
      expect(pack.valid?).to eq false
    end

    it "Should be invalid w/o a price" do
      pack = build(:pack, price: "")
      expect(pack.valid?).to eq false
    end

    it "Should be invalid if the title is already taken" do
      create(:pack, title: "zuber pack")
      pack = Pack.new(title: "zuber pack", price: 100)
      expect(pack.valid?).to eq false
    end

  end
end
