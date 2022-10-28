# Capybara's screenshots
# Capybara::Screenshot.screenshot_and_save_page

require 'rails_helper'
Prawn::Fonts::AFM.hide_m17n_warning = true


RSpec.describe "dashboard_journey", type: :system do
  before do
    sign_in User.first
    create(:pack, level: 1)
    create(:pack, level: 2)
    create(:pack, level: 3)
    create(:account, subcategory: create(:subcategory, name: 'Mobile', category: create(:category, name: 'Telecom')))
  end

  describe "User journey" do
    ## --------------------------------------------------------------------------------------------------
    ## Journey steps
    ## --------------------------------------------------------------------------------------------------
    def visit_dashboard
      create(:order, user: User.first, paid: true)
      visit "/utilisateurs/#{User.first.slug}"
    end

    def visit_order_show
      num_tel = create(:document, name: "numero telephone", format: 'text')
      num_contract = create(:document, name: "numero contrat", format: 'text')
      create(:account_document, account: Account.last, document: num_tel)
      create(:account_document, account: Account.last, document: num_contract)
      order = create(:order, user: User.first, paid: true)
      create(:order_account, order:, account: Account.last)
      create(:order_document, order:, document: num_tel)
      create(:order_document, order:, document: num_contract)
      visit "/utilisateurs/#{User.first.slug}"
      page.find('.user-dashboard-content').find('a').click
    end


    ## --------------------------------------------------------------------------------------------------
    ## Journey tests
    ## --------------------------------------------------------------------------------------------------

    # User#show
    it "User can login to dashboard" do
      visit_dashboard
      expect(page).to have_text "Bienvenue sur votre espace personnel"
    end

    it "User sees last order" do
      visit_dashboard
      expect(page).to have_text "Nombre de contrats à résilier"
      Capybara::Screenshot.screenshot_and_save_page
    end

    # Order#show
    it "User can visit order#show" do
      visit_order_show
      expect(page).to have_text ("État des contrats à résilier")
      Capybara::Screenshot.screenshot_and_save_page
    end

    it "Displays the right amout of order_account_cards" do
      visit_order_show
      expect(page.all('.order-account-card').count).to eq 1
    end

    it "Displays the right amout of inputs" do
      visit_order_show
      expect(page.all('input').count).to eq 4
    end

    it "Displays order_account status on card" do
      visit_order_show
      expect(page).to have_text("Document(s) manquant(s)")
    end

    it "Input disapears when filled" do
      visit_order_show
      fill_in('order_document[document_input]', match: :first, with: 'abcdef').native.send_keys(:enter)
      sleep 2
      expect(page.all('input').count).to eq 2
    end

    it "State machine should change aasm to 'pending' once the second input is filled and view should display it" do
      visit_order_show
      fill_in('order_document[document_input]', match: :first, with: 'abcdef').native.send_keys(:enter)
      sleep 0.2
      fill_in('order_document[document_input]', match: :first, with: 'hijkl').native.send_keys(:enter)
      sleep 2
      expect(page.all('input').count).to eq 0
      expect(page).to have_text("En traitement")
    end
  end
end
