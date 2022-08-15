class OrderAccountsController < ApplicationController
  before_action :set_order_account, only: %i[show]

  def show
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        pdf = OrderAccountPdf.new(@order_account)
        pdf.resiliation_pdf
        send_data pdf.render,
                  filename: "export.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:id])
  end
end
