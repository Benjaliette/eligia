class OrderPdf < TemplatePdf
  require 'combine_pdf'
  require 'prawn'
  require 'net/http'

  def initialize(order)
    @order = order
  end

  def prawn_invoice(args = build_args)
    super
  end

  def build_and_upload_invoice
    @order.invoice_file.attach(io: StringIO.new(self.prawn_invoice.render), filename: "facuture-eligia.pdf", content_type: "application/pdf")
  end

  private

  def build_args
    { order: @order }
  end
end
