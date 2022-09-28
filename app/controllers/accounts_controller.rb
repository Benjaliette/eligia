class AccountsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]
  before_action :set_categories, only: %i[create]

  def create
    @accounts = Account.search_by_name(account_params["name"])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('account-search-results', partial: "accounts/accounts_search_results",
          locals: { accounts: @accounts })
      end
      format.html { redirect_to new_order_path, notice: "Le compte a bien été ajouté à la liste" }
    end
  end

  private

  def set_categories
    @categories = Category.all
  end

  def account_params
    params.require(:account).permit(:name, :order_id)
  end
end
