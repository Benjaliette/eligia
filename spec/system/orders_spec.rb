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
      visit "/orders/new"
      expect(page).to have_text("Prénom du défunt")
    end

    it "Create order" do
      create(:pack, title: 'packTitle1', level: 1)
      create(:pack, title: 'packTitle2', level: 2)
      create(:pack, title: 'packTitle3', level: 3)
      create_list(:account, 4, subcategory: create(:subcategory, name: 'Mobile', category: create(:category, name: 'Telecom')), status: 'validated')
      create(:account_document, account: Account.last, document: create(:document, name:"id"))
      create(:account_document, account: Account.last, document: create(:document, name:"certificat"))
      visit "/orders/new"
      expect(page).to have_text(Account.last.name)
      fill_in "order[deceased_first_name]", with: "Johnny"
      fill_in "order[deceased_last_name]", with: "Halliday"
      page.find(class: 'account-radio-button-text', text: Account.last.name).click
      page.find(class: 'learn-more').click
      expect(page).to have_text("fournir")
    end
  end
end
