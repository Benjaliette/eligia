class OrderAccountPdf < TemplatePdf
  require 'combine_pdf'
  require 'prawn'
  require 'net/http'

  def initialize(order_account)
    @order_account = order_account
  end

  def build_and_merge
    merged_pdf = CombinePDF.new
    # merged_pdf << CombinePDF.parse(self.render)
    @order_account.order_documents.each do |order_document|
      if order_document.pdf?
        merged_pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(order_document.document_file.url)).body)
      end
    end
    merged_pdf.save("test_pdf.pdf")
  end

  def resiliation_pdf(args = build_args)
    super
  end

  private

  def build_args
    { order_account: @order_account }
  end
end
