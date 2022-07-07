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

  describe "#determine_pack_type" do

    it "Should assign pack #1 for 4 OrderAccounts" do
      create(:pack, title: 'packTitle1')
      create(:pack, title: 'packTitle2')
      create(:pack, title: 'packTitle3')
      create(:pack, title: 'packTitle4')
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 4, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle1")
    end

    it "Should not assign pack #2 for 4 OrderAccounts" do
      create(:pack, title: 'packTitle1')
      create(:pack, title: 'packTitle2')
      create(:pack, title: 'packTitle3')
      create(:pack, title: 'packTitle4')
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 4, order: order)
      expect(order.determine_pack_type.title).not_to eq("packTitle2")
    end

    it "Should assign pack #3 for 11 OrderAccounts" do
      create(:pack, title: 'packTitle1')
      create(:pack, title: 'packTitle2')
      create(:pack, title: 'packTitle3')
      create(:pack, title: 'packTitle4')
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 11, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle3")
    end

    it "Should not assign pack #4 for 11 OrderAccounts" do
      create(:pack, title: 'packTitle1')
      create(:pack, title: 'packTitle2')
      create(:pack, title: 'packTitle3')
      create(:pack, title: 'packTitle4')
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 4, order: order)
      expect(order.determine_pack_type.title).not_to eq("packTitle4")
    end

  end
end
