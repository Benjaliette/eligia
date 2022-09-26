class OrderAccountsController < ApplicationController
  before_action :set_order_account, only: %i[show edit update]
  before_action :set_order, only: %i[show]
  before_action :set_pundit_order_account, only: %i[show]

  def show
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.update_order_account_status
    @order.update_state
    @order_documents = @order_account.order_documents
  end

  private

  def set_order_account
    @order_account = OrderAccount.find(params[:id])
  end

  def set_order
    @order = Order.friendly.find(params[:order_id])
  end

  def set_pundit_order_account
    authorize @order_account
  end
end
