# added this in order to get ReCaptcha working
# code comes from https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise

class RegistrationsController < Devise::RegistrationsController
  # this only fires on production - I develop mainly offline
  prepend_before_action :check_captcha, only: [:create] if Rails.env.production?

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides Recaptcha
        set_minimum_password_length
        respond_with resource
      end
    end
end
