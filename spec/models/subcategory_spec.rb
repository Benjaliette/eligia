require 'rails_helper'

RSpec.describe Subcategory, type: :model do

  context "Creating a subcategory" do

    it "Should be valid when it has a name and an existing category" do
      subcategory = build(:subcategory)
      expect(subcategory.valid?).to eq true
    end

    it "Should have a unique name" do
      create(:subcategory)
      subcategory = Subcategory.new(name: 'subcateforyName')
      expect(subcategory.valid?).to eq false
    end
  end
end
