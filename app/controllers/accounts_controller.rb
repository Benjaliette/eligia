class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    @accounts = Account.where(aasm_state: "validated").where("name ILIKE ?", "%#{account_params["name"]}%")
    @other_account_name = account_params["name"]
    @order = Order.find(account_params["order_id"])

    respond_to do |format|
      format.turbo_stream do
        if account_params["name"].empty?
          render turbo_stream: turbo_stream.update('account-search-results', partial: "accounts/accounts_search_results",
            locals: { accounts: [] })
        else
          render turbo_stream: turbo_stream.update('account-search-results', partial: "accounts/accounts_search_results",
            locals: { accounts: @accounts, order: @order, other_account_name: @other_account_name })
        end
      end
      format.html { redirect_to created_order_path(@order) }
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :order_id)
  end
end
