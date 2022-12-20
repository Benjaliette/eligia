class Documents::OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[edit update]

  before_action :set_order, only: %i[edit update]
  after_action :order_pundit, only: %i[edit update]

  def edit
    @order_documents_json = @order.jsonify_order_documents
    @order_text_documents = @order.order_documents.select { |od| od.document.format == 'text' }
    @order_file_documents = @order.order_documents.select { |od| od.document.format == 'file' }
  end

  def update
    @order_text_documents = @order.order_documents.select { |od| od.document.format == 'text' }
    @order_file_documents = @order.order_documents.select { |od| od.document.format == 'file' }

    if @order.update(order_params) && params[:order]
      @order.update_order_account_status
      redirect_to order_path(@order)
    else
      render :edit
    end
  end

  private

  def order_pundit
    authorize @order
  end

  def order_params
    params.require(:order).permit(
      :deceased_first_name,
      :deceased_last_name,
      order_documents_attributes: [
        :id,
        :document_id,
        :document_file,
        :document_input
      ],
      address_attributes: [
        :id,
        :street,
        :complement,
        :zip,
        :state,
        :city
      ]
    )
  end

  def set_order
    @order = Order.friendly.find(params[:id]).decorate
  end
end
