require 'rails_helper'

RSpec.describe Category, type: :model do
  context "Creating categories" do

    it "Should have a name" do
      category = build_stubbed(:category, name: 'Telecom')
      expect(category.valid?).to eq true
    end

    it "Should have a unique name" do
      create(:category, name: 'Telecom')
      category2 = Category.new(name: 'Telecom')
      expect(category2.valid?).to eq false
    end
  end
end
