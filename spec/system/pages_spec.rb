require 'rails_helper'

if User.count.zero?
  User.create(first_name: 'Tester', last_name: 'Joe', email:'tester.joe@test.fr', password: '123456')
end

RSpec.describe "pages", type: :system do
  before :example do
    sign_in User.first
  end

  context "pages#home" do

    # See pages#home
    it "Can find catch phrase" do
      visit "/"
      expect(page).to have_text("Résiliez en 10 minutes tous les\nabonnements d'un proche disparu")
    end

    # Access pages#price
    it "Has a link towarts /pages/price" do
      visit "/"
      expect(page).to have_link(nil, href: '/pages/price')
    end

    it "Can click the link towarts /pages/price and see the page title" do
      visit "/"
      click_link(nil, href: '/pages/price', match: :first)
      expect(page).to have_text("tarifs")
    end

    # Access pages#contact
    it "Has a link towarts /contact/new" do
      visit "/"
      expect(page).to have_link(nil, href: '/contact/new')
    end

    it "Can click the link towarts /contact/new and see the page title" do
      visit "/"
      click_link(nil, href: '/contact/new', match: :first)
      expect(page).to have_text("Votre message")
    end

    # Access orders#new
    it "Has a link towarts /orders/new" do
      visit "/"
      expect(page).to have_link(nil, href: '/orders/new')
    end

    it "Can click the link towarts /orders/new" do
      visit "/"
      click_link(nil, href: '/orders/new')
      expect(page).to have_text("Prénom du défunt")
    end
  end
end
