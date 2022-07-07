require 'rails_helper'

RSpec.describe "pages", type: :system do
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
      click_link(nil, href: '/pages/price')
      expect(page).to have_text("Page des prix")
    end

    # Access pages#contact
    it "Has a link towarts /pages/contact" do
      visit "/"
      expect(page).to have_link(nil, href: '/pages/contact')
    end

    it "Can click the link towarts /pages/price and see the page title" do
      visit "/"
      click_link(nil, href: '/pages/contact')
      expect(page).to have_text("Page de contact")
    end

    # Access orders#new
    it "Has a link towarts /orders/new" do
      visit "/"
      expect(page).to have_link(nil, href: '/pages/contact')
    end

    it "Can click the link towarts /orders/new" do
      visit "/"
      click_link(nil, href: '/orders/new')
      expect(page).to have_text("S'identifier")
    end
  end
end
