class OrderAccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_order_account, only: %i[show edit update destroy]
  before_action :set_order, only: %i[show]
  after_action :set_pundit_order_account, only: %i[show create destroy]

  def show
    @order_documents = @order_account.order_documents
  end

  def create
    @order_account = OrderAccount.create(order_account_params)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('account-list', partial: "order_accounts/account_list_card",
            locals: { order_account: @order_account }),
          turbo_stream.update('account-number', " (#{@order_account.order.order_accounts.size}) "),
          turbo_stream.update('contract-number', @order_account.order.order_accounts.size)
        ]
      end
      format.html { redirect_to new_order_path, notice: "Le compte a bien été ajouté à la liste" }
    end
  end

  def destroy
    @order = @order_account.order
    @order_account.account.destroy if @order_account.account.non_validated?
    @order_account.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@order_account),
          turbo_stream.update(@order_account.account.subcategory, partial: "orders/chose_account_form",
            locals: { order: @order, subcategory: @order_account.account.subcategory, category: @order_account.account.subcategory.category }),
          turbo_stream.update('account-number', " (#{@order.order_accounts.size}) "),
          turbo_stream.update('contract-number', @order.order_accounts.size)
        ]
      end
      format.html { render 'order/new' }
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
