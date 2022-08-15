class OrderAccountPdf < TemplatePdf
  def initialize(order_account)
    @order_account = order_account
  end

  def resiliation_pdf(args = build_args)
    super
  end

  private

  def build_args
    { order_account: @order_account }
  end
end
