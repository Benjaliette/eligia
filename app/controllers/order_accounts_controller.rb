class OrderAccountsController < ApplicationController
  before_action :set_order_account, only: %i[show edit update]
  before_action :set_order, only: %i[show]
  after_action :set_pundit_order_account, only: %i[show create]

  def show
    @orders = current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @order.update_order_account_status
    @order.update_state
    @order_documents = @order_account.order_documents
  end

  def create
    @order_account = OrderAccount.create(order_account_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('test', partial: "order_accounts/account_card",
          locals: { order_account: @order_account })
      end
      format.html { redirect_to new_order_path, notice: "Le compte a bien été ajouté à la liste" }
    end
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

  def order_account_params
    params.require(:order_account).permit(
      :id,
      :account_id,
      :order_id,
      account_attributes: [
        :_destroy,
        :name,
        :subcategory_id
      ]
    )
  end
end
