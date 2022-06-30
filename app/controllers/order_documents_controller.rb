class OrderDocumentsController < ApplicationController
  def create
    @order_document = OrderDocument.new(order_document_params)
    @order_document.save
  end

  private

  def order_document_params
    params.require(:order_document).permit(%i[order_id document_id document_file])
  end
end
