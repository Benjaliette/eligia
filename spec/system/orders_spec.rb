# Capybara's screenshots
# Capybara::Screenshot.screenshot_and_save_page
# Capybara::Screenshot.screenshot_and_open_image

require 'rails_helper'

RSpec.describe "pages", type: :system do
  before :example do
    sign_in User.first
  end

  context "When creating an order" do
    it "Accesses the orders/new page" do
      visit "/orders/new"
      expect(page).to have_text("Première étape")
    end

    it "Create order" do
      create_list(:account, 4, subcategory: create(:subcategory, name: 'Mobile', category: create(:category, name: 'Telecom')), status: 'validated')
      visit "/orders/new"
      expect(page).to have_text("accountName1")
      fill_in "order[deceased_first_name]", with: "Johnny"
      fill_in "order[deceased_last_name]", with: "Halliday"
      page.find(class: 'account-radio-button-text', text: 'accountName1').click
      Capybara::Screenshot.screenshot_and_save_page
    end
  end
end
