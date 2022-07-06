require 'rails_helper'

RSpec.describe Order, type: :model do

  context "When creating an order" do
    it "Should be valid with a deceased_first/last_name and user" do
      order = build(:order)
      expect(order.valid?).to eq true
    end

    it "Should be invalid w/o a deceased_first_name" do
      order = build(:order, deceased_first_name: "")
      expect(order.valid?).to eq false
    end

    it "Should be invalid w/o a deceased_last_name" do
      order = build(:order, deceased_last_name: "")
      expect(order.valid?).to eq false
    end

    it "Should be invalid if deceased_first_name does not match regex" do
      order = build(:order, deceased_first_name: "m4rc")
      expect(order.valid?).to eq false
    end

    it "Should be invalid if deceased_first_name does not match regex" do
      order = build(:order, deceased_last_name: "doe!")
      expect(order.valid?).to eq false
    end
  end

  # describe "#determine_pack_type" do

  #   it "Should assign pack #1 for 4 OrderAccounts" do
  #     create_list(:pack, 4)
  #     default_pack = create(:pack, title: 'Default_pack', price: 2000)
  #     order = create(:order, pack: default_pack)
  #     build_stubbed_list(:order_account, 4, order: order)
  #     expect(order.determine_pack_type).to eq Pack.find_by(title: 'packTitle1')
  #   end

  #   it "Should assign pack #2 for 10 OrderAccounts" do
  #     create_list(:pack, 4)
  #     default_pack = create(:pack, title: 'Default_pack', price: 2000)
  #     order = create(:order, pack: default_pack)
  #     build_stubbed_list(:order_account, 10, order: order)
  #     expect(order.determine_pack_type).to eq Pack.find_by(title: 'packTitle2')
  #   end

  #   it "Should assign pack #3 for 11 OrderAccounts" do
  #     create_list(:pack, 4)
  #     default_pack = build_stubbed(:pack, title: 'Default_pack', price: 2000)
  #     order = build_stubbed(:order, pack: default_pack)
  #     build_stubbed_list(:order_account, 11, order: order)
  #     expect(order.determine_pack_type).to eq Pack.find_by(title: 'packTitle2')
  #   end
  end
end
