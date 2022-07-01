class OrderDocumentsController < ApplicationController
  def create
    @order_document = OrderDocument.new(order_document_params)
    @order_document.save
    redirect_to add_documents_order_path(Order.find(params[:order_id]))
  end

  def update
    @order_document = OrderDocument.find(params[:id])
    @order_document.update(order_document_params)
    @order_document.save
    redirect_to add_documents_order_path(Order.find(params[:order_id]))
  end

  private

  def order_document_params
    params.require(:order_document).permit(%i[order_id document_id document_file])
  end
end
