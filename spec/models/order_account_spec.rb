require 'rails_helper'

RSpec.describe OrderAccount, type: :model do
  describe "When creating an order_acount" do
    it "Should be valid with an order and an account" do
      order_account = build(:order_account)
      expect(order_account.valid?).to eq true
    end

    it "Should not be valid w/o an order" do
      order_account = build(:order_account, order: nil)
      expect(order_account.valid?).to eq false
    end

    it "Should not be valid w/o an account" do
      order_account = build(:order_account, account: nil)
      expect(order_account.valid?).to eq false
    end
  end

  describe "State machine" do
    it "Can transition from document_missing to pending and resiliation_failure" do
      order_account = create(:order_account)
      expect(order_account).to allow_event(:declare_pending)
      expect(order_account).to transition_from(:document_missing).to(:resiliation_failure).on_event(:declare_resiliation_failure)
    end

    it "Should not allow transition from document_missing to incorrect states" do
      order_account = create(:order_account)
      expect(order_account).not_to allow_event(:declare_resiliation_sent)
      expect(order_account).not_to allow_event(:declare_resiliation_success)
    end

    it "Can transition from pending to resiliation_sent and resiliation_failure" do
      order_account = create(:order_account, aasm_state: 'pending')
      expect(order_account).to transition_from(:pending).to(:resiliation_sent).on_event(:declare_resiliation_sent)
      expect(order_account).to transition_from(:pending).to(:resiliation_failure).on_event(:declare_resiliation_failure)
    end

    it "Should not allow transition from pending to incorrect states" do
      order_account = create(:order_account, aasm_state: 'pending')
      expect(order_account).not_to allow_event(:declare_resiliation_success)
    end

    it "Can transition from resiliation_sent to resiliation_success and resiliation_failure" do
      order_account = create(:order_account, aasm_state: 'resiliation_sent')
      expect(order_account).to transition_from(:resiliation_sent).to(:resiliation_success).on_event(:declare_resiliation_success)
      expect(order_account).to transition_from(:resiliation_sent).to(:resiliation_failure).on_event(:declare_resiliation_failure)
    end

    it "Should not allow transition from resiliation_sent to incorrect states" do
      order_account = create(:order_account, aasm_state: 'resiliation_sent')
      expect(order_account).not_to allow_event(:declare_pending)
    end

    it "has appropriate state_to_french names" do
      my_user = create(:user, email: "marc.delesalle@eligia.fr")
      order_account = create(:order_account)
      expect(order_account.state_to_french).to eq "Document(s) manquant(s)"
      order_account.update(aasm_state: "pending")
      expect(order_account.state_to_french).to eq "En traitement"
      order_account.declare_resiliation_sent
      expect(order_account.state_to_french).to eq "Demande de résiliation envoyée"
      order_account.declare_resiliation_success
      expect(order_account.state_to_french).to eq "Compte résilié"
      order_account = create(:order_account, aasm_state: 'resiliation_failure', order: create(:order, user: my_user))
      expect(order_account.state_to_french).to eq "Erreur"
    end

    it "#update_state" do
      order = create(:order)
      orange = create(:account, name: "orange")
      certif = create(:document, name: "certif", format: "text")
      id = create(:document, name: "id", format: "text")
      mail = create(:document, name: "mail", format: "text")
      create(:account_document, account: orange, document: certif)
      create(:account_document, account: orange, document: mail)
      create(:account_document, account: orange, document: id)
      create(:order_document, order:, document: mail, document_input: "yellow")
      create(:order_document, order:, document: id, document_input: "yellow")
      create(:order_document, order:, document: certif, document_input: "yellow")
      order_account = create(:order_account, account: orange, order:)
      expect(order_account.aasm_state).to eq "document_missing"
      expect { order_account.update_state }.to raise_error NoMethodError
    end
  end

  describe "Fuctions returning docs and order_docs" do
    it "#required_documents" do
      orange = create(:account, name: "orange")
      certif = create(:document, name: "certif")
      id = create(:document, name: "id")
      mail = create(:document, name: "mail")
      create(:account_document, account: orange, document: certif)
      create(:account_document, account: orange, document: mail)
      create(:account_document, account: orange, document: id)
      order_account = create(:order_account, account: orange)
      expect(order_account.required_documents).to match_array([mail, id, certif])
    end

    it "#non_uploaded_order_documents" do
      order = create(:order)
      orange = create(:account, name: "orange")
      certif = create(:document, name: "certif")
      id = create(:document, name: "id")
      mail = create(:document, name: "mail", format: "text")
      create(:account_document, account: orange, document: certif)
      create(:account_document, account: orange, document: mail)
      create(:account_document, account: orange, document: id)
      order_account = create(:order_account, account: orange, order:)
      create(:order_document, order:, document: mail, document_input: 'yelloww')
      o_d_id = create(:order_document, order:, document: id)
      o_d_certif = create(:order_document, order:, document: certif)
      expect(order_account.non_uploaded_order_documents).to match_array([o_d_id, o_d_certif])
      expect(order_account.non_uploaded_order_documents).not_to match_array([o_d_id])
      expect(order_account.non_uploaded_order_documents).not_to match_array([o_d_id, o_d_certif, id])
    end

    it "#order_documents" do
      order = create(:order)
      orange = create(:account, name: "orange")
      certif = create(:document, name: "certif")
      id = create(:document, name: "id")
      mail = create(:document, name: "mail", format: "text")
      create(:account_document, account: orange, document: certif)
      create(:account_document, account: orange, document: mail)
      create(:account_document, account: orange, document: id)
      order_account = create(:order_account, account: orange, order:)
      o_d_mail = create(:order_document, order:, document: mail)
      o_d_id = create(:order_document, order:, document: id)
      o_d_certif = create(:order_document, order:, document: certif)
      expect(order_account.order_documents).to match_array([o_d_id, o_d_certif, o_d_mail])
      expect(order_account.order_documents).not_to match_array([o_d_id])
      expect(order_account.order_documents).not_to match_array([o_d_id, o_d_certif, id])
    end
  end
end
