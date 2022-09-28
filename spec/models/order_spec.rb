require 'rails_helper'

RSpec.describe Order, type: :model do

  context "When updating an order" do
    it "Should be valid with a deceased_first/last_name and user" do
      order = build(:order)
      expect(order.valid?).to eq true
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
  end

  describe "Filters the right documents" do
    it "#required_documents" do
      order = create(:order)
      orange = create(:account, name: "orange")
      sfr = create(:account, name: "sfr")
      certif = create(:document, name: "certif")
      id = create(:document, name: "id")
      mail = create(:document, name: "mail", format: "text")
      create(:account_document, account: sfr, document: certif)
      create(:account_document, account: orange, document: mail)
      create(:account_document, account: orange, document: id)
      create(:order_account, account: orange, order:)
      create(:order_account, account: sfr, order:)
      create(:order_document, order:, document: mail)
      create(:order_document, order:, document: id)
      create(:order_document, order:, document: certif)
      expect(order.required_documents).to match_array([certif, id, mail])
      expect(order.required_documents).not_to match_array([certif])
      expect(order.required_documents).not_to match_array([certif, id, mail, order])
    end
  end

  describe "State machine" do
    it "Can transition from pending to processing" do
      order = create(:order)
      expect(order).to transition_from(:pending).to(:processing).on_event(:declare_processing)
    end

    it "Cannot transition from pending to done" do
      order = create(:order)
      expect(order).not_to transition_from(:pending).to(:done).on_event(:declare_done)
    end

    it "Can transition from processing to done" do
      order = create(:order)
      expect(order).to transition_from(:processing).to(:done).on_event(:declare_done)
    end
  end

  describe "Updating state machine" do
    it "#update_state --> from pending to processing" do
      order = create(:order)
      expect(order.aasm_state).to eq "pending"
      create(:order_account, order:, aasm_state: "pending")
      create(:order_account, order:, aasm_state: "pending")
      order.update_state
      expect(order.aasm_state).to eq "processing"
    end

    it "#update_state --> from processing to done" do
      order = create(:order, aasm_state: "processing")
      create(:order_account, order:, aasm_state: "resiliation_success")
      create(:order_account, order:, aasm_state: "resiliation_success")
      order.update_state
      expect(order.aasm_state).to eq "done"
    end
  end

  describe "Generating order_documents" do
    it "#generate_order_documents" do
    order = create(:order)
    create(:order_document, order:)
    expect(order.order_documents.count).to eq 1
    account_1 = create(:account)
    account_2 = create(:account)
    doc_1 = create(:document)
    doc_2 = create(:document)
    doc_3 = create(:document)
    create(:account_document, account: account_1, document: doc_1)
    create(:account_document, account: account_1, document: doc_2)
    create(:account_document, account: account_2, document: doc_3)
    create(:order_account, account: account_1, order:)
    create(:order_account, account: account_2, order:)
    order.generate_order_documents
    expect(order.order_documents.count).to eq 3
    end
  end
end
