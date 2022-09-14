class UsersController < ApplicationController
  before_action :set_user, only: %i[show control_password control_password_check edit update]

  after_action :user_pundit, only: %i[show control_password control_password_check edit update]

  def index
  end

  def show
    # .order = tri activerecord
    @orders = @current_user.orders.where(paid: true).order(:deceased_last_name, :deceased_first_name)
    @notifications = @current_user.notifications.order(created_at: :desc)
    @last_order = @current_user.orders.where(paid: true).last
  end

  def control_password
  end

  def control_password_check
    if @current_user.valid_password?(check_password_params[:current_password])
      redirect_to edit_user_path(@current_user)
    else
      flash[:alert] = "Le mot de passe entré n'est pas le bon"
      render :control_password
    end
  end

  def edit
  end

  def update
    if @current_user.update(user_params)
      bypass_sign_in(@current_user)
      flash[:success] = 'Mot de passe modifié'
      redirect_to user_path(@current_user)
    else
      flash[:alert] = "Les deux mots de passes ne sont pas les mêmes"
      render :edit
    end
  end

  private

  def set_user
    @current_user = User.friendly.find(current_user.id)
  end

  def user_pundit
    authorize @current_user
  end

  def check_password_params
    params.require(:user).permit(:current_password)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
