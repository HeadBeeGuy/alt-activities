class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #added as per https://stackoverflow.com/questions/20126106/devise-error-email-cant-be-blank
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  
  def configure_permitted_parameters
    # apparently "permit" makes this work with Rails 5
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end
  
  #added as per Rails i18n guide
  before_action :set_locale
  
  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
  end

	# this comes straight from the official Rails guide
	def extract_locale_from_subdomain
		parsed_locale = request.subdomains.first
		I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
	end
  
  #code from Pundit documentation - very useful!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    def user_not_authorized
      flash[:warning] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_url)
    end
end
