class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
  end

  def show
    # .order = tri activerecord
    @orders = @current_user.orders.order(:deceased_last_name, :deceased_first_name)
  end

  private

  def set_user
    @current_user = User.friendly.find(current_user.id)
  end
end
