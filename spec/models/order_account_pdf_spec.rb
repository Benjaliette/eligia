require 'rails_helper'
Prawn::Fonts::AFM.hide_m17n_warning = true

RSpec.describe OrderAccountPdf, type: :model do
  describe "Analyzing pdf" do
    it "has at least one page" do
      order_account = create(:order_account)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      page_analysis = PDF::Inspector::Page.analyze(rendered_pdf)
      expect(page_analysis.pages.size).to be >= 1
    end

    it "has Eligia's Expedition Address" do
      order_account = create(:order_account)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
      expect(text_analysis.strings).to include "ELIGIA SARL,"
      expect(text_analysis.strings).to include "6 rue Flornoy, 33000"
      expect(text_analysis.strings).to include "Bordeaux"
    end

    it "has the deceased name" do
      order_account = create(:order_account)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
      expect(text_analysis.strings).to include "Au nom de #{order_account.order.deceased_first_name} #{order_account.order.deceased_last_name}"
    end

    it "has the deceased name" do
      order_account = create(:order_account)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
      expect(text_analysis.strings).to include "Au nom de #{order_account.order.deceased_first_name} #{order_account.order.deceased_last_name}"
    end

    it "manages 1 document_input info" do
      order = create(:order)
      document = create(:document, format: 'text')
      account = create(:account)
      create(:order_document, document_input: "7his !s a document inpu~t", order:, document:)
      create(:account_document, account:, document:)
      order_account = create(:order_account, order:, account:)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
      expect(text_analysis.strings.join(" ")).to include "7his !s a document inpu~t"
    end

    it "manages 1 document_input info" do
      order = create(:order)
      document = create(:document, format: 'text')
      document2 = create(:document, format: 'text')
      account = create(:account)
      create(:order_document, document_input: "7his !s a document inpu~t", order:, document:)
      create(:order_document, document_input: "4nother on3", order:, document: document2)
      create(:account_document, account:, document:)
      create(:account_document, account:, document: document2)
      order_account = create(:order_account, order:, account:)
      order_account_pdf = OrderAccountPdf.new(order_account)
      rendered_pdf = order_account_pdf.prawn_resiliation.render
      text_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
      expect(text_analysis.strings.join(" ")).to include "7his !s a document inpu~t"
      expect(text_analysis.strings.join(" ")).to include "4nother on3"
    end
  end
end
