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
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 4, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle1")
    end

    it "Should not assign pack #2 for 7 OrderAccounts" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 7, order: order)
      expect(order.determine_pack_type.title).not_to eq("packTitle2")
    end

    it "Should assign pack #2 for 8 OrderAccounts" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 8, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle2")
    end

    it "Should not assign pack #3 for 15 OrderAccounts" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 15, order: order)
      expect(order.determine_pack_type.title).not_to eq("packTitle3")
    end

    it "Should assign pack #3 for 16 OrderAccounts" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 16, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle3")
    end

    it "Should assign pack #3 for 100 OrderAccounts" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      order = create(:order, pack: Pack.first)
      create_list(:order_account, 100, order: order)
      expect(order.determine_pack_type.title).to eq("packTitle3")
    end
  end

  describe "#required_documents" do
    it "Should return the 2 appropriate documents in an array" do
      order = create(:order)
      sfr = create(:account, name: "sfr")
      create(:order_account, order: order, account: sfr)
      create(:account_document, account: sfr, document: create(:document, name: "id"))
      create(:account_document, account: sfr, document: create(:document, name: "certif"))
      expect(order.required_documents.sort).to eq([Document.find_by(name: "id"), Document.find_by(name: "certif")].sort)
    end

    it "Should be able to manage multiple order_accounts" do
      order = create(:order)
      sfr = create(:account, name: "sfr")
      orange = create(:account, name: "orange")
      create(:order_account, order: order, account: sfr)
      create(:order_account, order: order, account: orange)
      create(:account_document, account: sfr, document: create(:document, name: "id"))
      create(:account_document, account: sfr, document: create(:document, name: "certif"))
      create(:account_document, account: orange, document: Document.find_by(name: 'id'))
      create(:account_document, account: orange, document: create(:document, name: "doc3"))
      expect(order.required_documents.sort).to eq([Document.find_by(name: "id"), Document.find_by(name: "certif"), Document.find_by(name: "doc3")].sort)
    end

    it "Should have a working state machine" do
      order = create(:order)
      expect(order).to transition_from(:pending).to(:done).on_event(:declare_done)
    end
  end
end
