class OrderAccountPdf < TemplatePdf
  require 'combine_pdf'
  require 'prawn'
  require 'net/http'

  def initialize(order_account)
    @order_account = order_account
  end

  def build_and_upload_resiliation
    merged_pdf = CombinePDF.new
    merged_pdf << CombinePDF.parse(self.prawn_resiliation.render)
    @order_account.order_documents.each do |order_document|
      if order_document.pdf?
        merged_pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(order_document.document_file.url)).body, allow_optional_content: true)
      end
    end
    @order_account.resiliation_file.attach(io: StringIO.new(merged_pdf.to_pdf), filename: "file.pdf", content_type: "application/pdf")
  end

  def prawn_resiliation(args = build_args)
    super
  end

  private

  def build_args
    { order_account: @order_account }
  end
end
