class OrderAccountPdf < TemplatePdf
  def initialize(order_account)
    @order_account = order_account
  end

  def resiliation_pdf
    super(build_args)
  end

  private

  def build_args
    { sender_first_name: @order_account.order.deceased_first_name,
      sender_last_name: @order_account.order.deceased_last_name }
  end
end
