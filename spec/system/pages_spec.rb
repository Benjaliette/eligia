require 'rails_helper'

if User.count.zero?
  User.create(
    first_name: 'Tester',
    last_name: 'Joe',
    email: 'tester.joe@test.fr',
    address: '12 rue du test , 75000 Paris , FR',
    password: '123456',
    birthdate: Date.today - 20.years,
    accepted_rgpd: true,
    accepted_cgs: true
  )
end

RSpec.describe "pages", type: :system do
  before do
    sign_in User.first
  end

  context "pages#home" do
    it "Can find catch phrase" do
      visit "/"
      expect(page).to have_text("Résiliez en 10 minutes tous les\nabonnements d'un proche disparu")
    end

    it "Has a link towarts /pages/tarifs" do
      visit "/"
      expect(page).to have_link(nil, href: '/pages/tarifs')
    end

    it "Can click the link towarts /pages/price and see the page title" do
      visit "/"
      click_link(nil, href: '/pages/tarifs', match: :first)
      expect(page).to have_text("tarifs")
    end

    it "Has a link towarts /contact/new" do
      visit "/"
      expect(page).to have_link(nil, href: '/contact/nous-contacter')
    end

    it "Can click the link towarts /contact/new and see the page title" do
      visit "/"
      click_link(nil, href: '/contact/nous-contacter', match: :first)
      expect(page).to have_text("Votre message")
    end

    it "Has a link towarts /resiliations/contrats" do
      visit "/"
      expect(page).to have_link(nil, href: '/resiliations/new')
    end

    it "Can click the link towarts /resiliations/contrats" do
      visit "/"
      page.find(class: 'btn-call-to-a', text: 'Commencer').click
      expect(page).to have_text("Contrats à résilier")
    end
  end
end
