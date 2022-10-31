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

    it "Should be valid if name is already taken in another subcategory" do
      create(:account, name: "LeMonde", subcategory: create(:subcategory, name: "Media"))
      account = Account.new(name: "LeMonde", subcategory: create(:subcategory, name: "Game"))
      expect(account.valid?).to eq true
    end
  end

  describe "self.validated_accounts_from_subcategory" do
    it "should not return unvalidated accounts" do
      subcategory = create(:subcategory)
      5.times { create(:account, subcategory:, aasm_state:"non_validated") }
      expect(Account.validated_accounts_from_subcategory(subcategory).count).to eq 0
    end

    it "should return the right accounts" do
      subcategory = create(:subcategory)
      validated_accounts = []
      5.times do
        validated_accounts << create(:account, subcategory:)
      end
      expect(Account.validated_accounts_from_subcategory(subcategory)).to match_array validated_accounts
    end
  end

  describe "State Machine" do
    it "Accounts should be non_validated by default" do
      account = Account.create(name: "my_test_account")
      expect(account.aasm_state).to eq "non_validated"
    end

    it "should be able to transition from non_validated to validated" do
      order = create(:order)
      account = create(:account, aasm_state: "non_validated")
      create(:order_account, order:, account:)
      account.declare_validated!
      expect(account.aasm_state).to eq "validated"
    end

    it "should send 1 notification" do
      order = create(:order)
      account = create(:account, aasm_state: "non_validated")
      create(:order_account, order:, account:)
      expect(order.notifications.count).to eq 0
      account.declare_validated!
      expect(order.notifications.count).to eq 1
    end

    it "shoud send the right notification" do
      order = create(:order)
      account = create(:account, aasm_state: "non_validated")
      create(:order_account, order:, account:)
      account.declare_validated!
      expect(order.notifications.first.content).to include "Le contrat '#{account.name}' a été validé. Vous pouvez"
    end
  end
end
