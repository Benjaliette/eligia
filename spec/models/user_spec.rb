require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when creating an account' do
    let(:user) { User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin@eligia.fr', password: '123456') }

    it 'User should be valid when every field is completed' do
      expect(user.valid?).to eq true
    end

    # First Name
    it 'User should not be valid without a first_name' do
      user = User.new(last_name: 'Liet', email: 'benjamin.liet@eligia.fr', password: '123456')
      expect(user.valid?).to eq false
    end

    it 'User should not be valid with any non-word character in first_name' do
      user = User.new(first_name: 'Benjydu33', last_name: 'Liet', email: 'benjamin.liet@eligia.fr', password: '123456')
      expect(user.valid?).to eq false
    end

    # Last Name
    it 'User should not be valid without a last_name' do
      user = User.new(first_name: 'Benjamin', email: 'benjamin.liet@eligia.fr', password: '123456')
      expect(user.valid?).to eq false
    end

    it 'User should not be valid with any non-word character in last_name' do
      user = User.new(first_name: 'Benjamin', last_name: 'Liet!', email: 'benjamin.liet@eligia.fr', password: '123456')
      expect(user.valid?).to eq false
    end

    # Password
    it 'User should not be valid with password < 6 characters' do
      user = User.new(first_name: 'Benjamin', email: 'benjamin.liet@eligia.fr', password: '12345')
      expect(user.valid?).to eq false
    end

    # Email
    context 'User should not be valid if email does not match regex' do
      it 'should have an @' do
        user = User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin.lieteligia.fr', password: '123456')
        expect(user.valid?).to eq false
      end

      it 'cannot just be letters' do
        user = User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'benjaminlieteligiafr', password: '123456')
        expect(user.valid?).to eq false
      end

      it 'must have a domain' do
        user = User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin.liet@eligia', password: '123456')
        expect(user.valid?).to eq false
      end

      it 'there must not be a number in the domain' do
        user = User.new(first_name: 'Benjamin', last_name: 'Liet', email: 'benjamin.lieteligia.f3r', password: '123456')
        expect(user.valid?).to eq false
      end
    end
  end
end
