class Users::OrdersController < ApplicationController
  before_action :set_order, only: :show
  after_action :order_pundit, only: :show

  def show
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.update_order_account_status
  end

  private

  def order_pundit
    authorize [:user, @order]
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
