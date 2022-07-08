class UsersController < ApplicationController
  def show
    @orders = Order.where(user: current_user).order(:deceased_last_name).order(:deceased_first_name)
  end
end
