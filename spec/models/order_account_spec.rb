require 'rails_helper'

RSpec.describe OrderAccount, type: :model do
  describe "When creating an order_acount" do

    it "Should be valid with an order and an account" do
      order_account = build(:order_account)
      expect(order_account.valid?).to eq true
    end

    it "Should not be valid w/o an order" do
      order_account = build(:order_account, order: nil)
      expect(order_account.valid?).to eq false
    end

    it "Should not be valid w/o an account" do
      order_account = build(:order_account, account: nil)
      expect(order_account.valid?).to eq false
    end

  end
end
