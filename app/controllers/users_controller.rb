class UsersController < ApplicationController
  def index
  end

  def show
    # .order = tri activerecord
    @orders = current_user.orders.order(:deceased_last_name, :deceased_first_name)
  end
end
