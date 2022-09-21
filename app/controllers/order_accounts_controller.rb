class OrderAccountsController < ApplicationController
  before_action :set_order_account, only: %i[show edit update]

  def show
    pdf = OrderAccountPdf.new(@order_account)
    pdf.resiliation_pdf
    merged_pdf = pdf.build_and_merge
    send_data merged_pdf,
              filename: "export.pdf",
              type: 'application/pdf',
              disposition: 'inline'

    authorize @order_account
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:id])
  end
end
