# Capybara's screenshots
# Capybara::Screenshot.screenshot_and_save_page
# Capybara::Screenshot.screenshot_and_open_image

require 'rails_helper'
Prawn::Fonts::AFM.hide_m17n_warning = true


RSpec.describe "order_creation_journey", type: :system do
  before do
    sign_in User.first
    create(:pack, level: 1)
    create(:pack, level: 2)
    create(:pack, level: 3)
    create(:account, subcategory: create(:subcategory, name: 'Mobile', category: create(:category, name: 'Telecom')))
    create(:account_document, account: Account.last, document: create(:document, name: "numero telephone", format: 'text'))
    create(:account_document, account: Account.last, document: create(:document, name: "id"))
  end

  describe "Order creation journey" do
    ## --------------------------------------------------------------------------------------------------
    ## Journey steps
    ## --------------------------------------------------------------------------------------------------

    def access_created_page
      order = create(:order)
      visit "/resiliations/#{order.id}/contrats"
    end

    def click_on_subcategory
      page.find('.subcategory-div', text: 'Mobile').click
    end

    def select_an_account
      page.find('.account-card-btn', match: :first).click
    end

    def click_on_valider
      page.find('.learn-more').click
    end

    def step_one_complete
      access_created_page
      click_on_subcategory
      select_an_account
      click_on_valider
    end

    def fill_step_two
      fill_in('order[deceased_first_name]', with: 'lucky')
      fill_in('order[deceased_last_name]', with: 'luke')
      page.all('input').last.fill_in with: '0612345678'
    end

    def step_one_two_complete
      step_one_complete
      fill_step_two
      click_on_valider
    end


    ## --------------------------------------------------------------------------------------------------
    ## Journey Tests
    ## --------------------------------------------------------------------------------------------------


    # STEP 1 :
    it "Accesses the orders/created page" do
      access_created_page
      expect(page).to have_text("Contrats à résilier")
    end

    it "An account-card appears on the right hand side once we select a contract" do
      access_created_page
      click_on_subcategory
      previous_count = page.all('.account-card').count
      select_an_account
      expect(page).to have_selector('.account-card', count: previous_count + 1)
    end

    it "Click on 'valider' and land on 'documents à fournir'" do
      access_created_page
      click_on_subcategory
      select_an_account
      click_on_valider
      expect(page).to have_text("Documents à fournir")
    end

    # Step 2 :
    it "Fills deceased info" do
      step_one_complete
      fill_step_two
      expect(page).to have_field('order[order_documents_attributes][0][document_input]', with: '0612345678')
    end

    # Step 3 :
    it "Should show the recap page" do
      step_one_two_complete
      expect(page).to have_text("Récapitulatif")
    end

    it "Should display the right price" do
      step_one_two_complete
      expect(page).to have_text(Pack.find_by(level: 1).price)
    end

    it "Should display a missing document" do
      step_one_two_complete
      expect { page.find('.document-created-false') }.not_to raise_error
    end

    it "Should display a provided document" do
      step_one_two_complete
      expect { page.find('.document-created-true') }.not_to raise_error
    end
  end
end
