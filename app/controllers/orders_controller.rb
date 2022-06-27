class OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def create
    raise
    @order = Order.new(order_params)
    @order.user = current_user
    return unless @order.save

    redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit(%i[deceased_first_name deceased_last_name])
  end
end
