require 'rails_helper'

RSpec.describe User, type: :model do

  context 'when creating an account' do

    it 'User should be valid when every field is completed' do
      user = build(:user)
      expect(user.valid?).to eq true
    end

    # First Name
    it 'User should not be valid without a first_name' do
      user = build(:user, first_name: "", email: "john.doe@eligia.fr")
      expect(user.valid?).to eq false
    end

    it 'User should not be valid with any non-word character in first_name' do
      user = build(:user, first_name: "J0hn")
      expect(user.valid?).to eq false
    end

    # Last Name
    it 'User should not be valid without a last_name' do
      user = build(:user, last_name: "", email: "john.doe@eligia.fr")
      expect(user.valid?).to eq false
    end

    it 'User should not be valid with any non-word character in last_name' do
      user = build(:user, last_name: "Doe!")
      expect(user.valid?).to eq false
    end

    # Password
    it 'User should not be valid with password < 6 characters' do
      user = build(:user, password: '12345')
      expect(user.valid?).to eq false
    end

    it "User should not be valid with password being just spaces" do
      user = build(:user, password: '      ')
      expect(user.valid?).to eq false
    end

    # Email
    context 'User should not be valid if email does not match regex' do
      it 'should have an @' do
        user = build(:user, email: "johndoe.fr")
        expect(user.valid?).to eq false
      end

      it 'cannot just be string without @ our .' do
        user = build(:user, email: "johndoeeligiafr")
        expect(user.valid?).to eq false
      end

      it 'must have a domain' do
        user = build(:user, email: "johndoe@eligia")
        expect(user.valid?).to eq false
      end

      it 'there must not be a number in the domain' do
        user = build(:user, email: "john.doe@eligia.f3r")

      end
    end
  end
end
