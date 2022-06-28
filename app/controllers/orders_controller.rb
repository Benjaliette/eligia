class OrdersController < ApplicationController

  def new
    @order = Order.new
    @categories = Category.all
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    return unless @order.save

    redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit(
      :deceased_first_name,
      :deceased_last_name,
      order_accounts_attributes: [
        :account_id
      ]
    )
  end
end
