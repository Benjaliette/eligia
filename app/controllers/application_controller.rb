class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  add_flash_types :alert, :warning, :success

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name address phone_number accepted_rgpd accepted_cgs birthdate])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name address phone_number accepted_rgpd accepted_cgs birthdate])
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def storable_location?
    request.get? && !devise_controller? && !request.xhr? && params[:action] != 'cgs'
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)|(^messages$)|(^helps$)|(^accounts$)|(^notifications$)/
  end
end
