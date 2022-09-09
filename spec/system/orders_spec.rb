# Capybara's screenshots
# Capybara::Screenshot.screenshot_and_save_page
# Capybara::Screenshot.screenshot_and_open_image

require 'rails_helper'

RSpec.describe "orders", type: :system do
  before :example do
    sign_in User.first
  end

  context "When creating an order" do
    it "Accesses the orders/new page" do
      visit "/resiliations/contrats"
      expect(page).to have_text("Prénom du défunt")
    end

    it "Can fill the three steps of the form and pay" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      create_list(:account, 4, subcategory: create(:subcategory, name: 'Mobile', category: create(:category, name: 'Telecom')), status: 'validated')
      create(:account_document, account: Account.last, document: create(:document, name:"id"))
      create(:account_document, account: Account.last, document: create(:document, name:"certificat"))
      visit "/resiliations/contrats"
      expect(page).to have_text("Prénom")
      fill_in "order[deceased_first_name]", with: "Johnny"
      fill_in "order[deceased_last_name]", with: "Halliday"
      page.find(class: 'subcategory-div', text: 'Mobile').click
      page.find(class: 'account-radio-button-text', text: Account.last.name).click
      page.find(class: 'learn-more').click
      expect(page).to have_text("fournir")
      page.find(class: 'learn-more').click
      expect(page).to have_text("Récapitulatif")
      # page.find(class: 'learn-more').click
      # sleep 10
      # expect(page).to have_text("Pay with card")
      # fill_in "cardNumber", with: "4242424242424242"
      # fill_in "cardExpiry", with: "03/26"
      # fill_in "cardCvc", with: "032"
      # fill_in "billingName", with: "Joe Tester"
      # (fill_in "billingAddressLine1", with: "21 Rue Parlement Saint-Pierre").native.send_keys(:return)
      # fill_in "billingPostalCode", with: "33000"
      # fill_in "billingLocality", with: "Bordeaux"
      # page.find(class: 'SubmitButton-IconContainer').click
      # sleep 20
      # expect(page).to have_text("Merci Tester Joe")
    end

    it "Navigates to user dashboard" do
      visit "/utilisateurs/Joe"
      expect(page).to have_text("Bonjour Tester")
    end
  end
end
