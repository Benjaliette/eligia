class OrderDocumentsController < ApplicationController
  before_action :set_order_account, only: %i[index update]
  before_action :set_order_document, only: :update

  def index
    all_order_documents = OrderDocument.where(order: @order_account.order)
    @order_documents_to_complete = all_order_documents.select { |order_document| (order_document.document.format == 'pdf' && !order_document.document_file.attached?) || (order_document.document.format == 'text' && order_document.document_input.blank?)}
  end

  def update
    @order_document.update(order_document_params)
    if @order_document.save
      redirect_to order_account_order_documents_path(@order_account), status: :see_other
      flash[:alert] = "Document enregistré"
    else
      render order_account_order_documents_path(@order_account), status: :unprocessable_entity
    end
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:order_account_id])
  end

  def set_order_document
    @order_document = OrderDocument.find(params[:id])
  end

  def order_document_params
    params.require(:order_document).permit(:document_input, :document_file)
  end
end
