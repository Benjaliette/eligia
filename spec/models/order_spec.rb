require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'bl@eligia.fr', password: '123456') }
  let(:pack) { Pack.new(title: 'Pack', price: 100, level: 2) }
  let(:order) { Order.new(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user: user, pack: pack) }

  context "When creating an order" do
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

  describe "#determine_pack_type" do
    Category.create(name: 'Telecom')
    Subcategory.create(name: 'Ligne mobile', category: Category.find_by(name: 'Telecom'))
    Subcategory.create(name: 'Ligne fixe', category: Category.find_by(name: 'Telecom'))
    Account.create(name: 'Bouygues', subcategory: Subcategory.find_by(name: 'Ligne mobile'), status: 'validated')
    Account.create(name: 'Free', subcategory: Subcategory.find_by(name: 'Ligne fixe'), status: 'validated')
    my_pack = Pack.create(title: 'Pack', price: 100, level: 1)
    let(:order_account) { OrderAccount.create(order: order, account: Account.find_by(name: 'Bouygues')) }

    it "Assigns the appropriate pack to an order" do
      expect(order.determine_pack_type).to eq my_pack
    end

    it "Should not assign an unappropriate pack to an order" do
      expect(order.determine_pack_type).not_to eq Pack.where(level: 2).last
    end
  end

  describe "#required_documents" do
    User.create(first_name: 'Benjamin', last_name: 'Liet', email: 'bl@eligia.fr', password: '123456')
    Pack.create(title: 'Pack', price: 100, level: 2)
    order = Order.create(deceased_first_name: 'Marc', deceased_last_name: 'Delesalle', user: User.last, pack: Pack.last)
    Document.create(name: 'Certificat décès', format: 'pdf')
    Document.create(name: 'Pièce identité', format: 'pdf')
    AccountDocument.create(account: Account.find_by(name: 'Free'), document: Document.find_by(name: 'Certificat décès'))
    AccountDocument.create(account: Account.find_by(name: 'Free'), document: Document.find_by(name: 'Pièce identité'))
    OrderAccount.create(order: order, account: Account.find_by(name: 'Free'))

    it "Has the right required documents" do
      expect(order.required_documents.sort).to match_array [Document.find_by(name: 'Certificat décès'), Document.find_by(name: 'Pièce identité')].sort
    end
  end
end
