class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #added as per https://stackoverflow.com/questions/20126106/devise-error-email-cant-be-blank
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    # apparently "permit" makes this work with Rails 5
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end
end
