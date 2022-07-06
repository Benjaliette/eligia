require 'rails_helper'

RSpec.describe Order, type: :model do
  context "When creating an order" do
    let(:user) { User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'bl@eligia.fr', password: '123456') }
    let(:pack) { Pack.new(title: 'Pack', price_cents: 1000) }
    let(:order) { Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user: user, pack: pack) }

    it "Should be valid when everything is specified" do
      expect(order.valid?).to eq true
    end

    # Pack
    it "Should have a pack" do
      order = Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user: user)
      expect(order.valid?).to eq false
    end

    it "Should have a valid pack_id" do
      order = Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user: user, pack_id: 0)
      expect(order.valid?).to eq false
    end

    # User
    it "Should have a user" do
      order = Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', pack: pack)
      expect(order.valid?).to eq false
    end

    it "Should have a valid user_id" do
      order = Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user_id: 0, pack: pack)
      expect(order.valid?).to eq false
    end
  end
end
