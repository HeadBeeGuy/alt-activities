# added this in order to get ReCaptcha working
# code comes from https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise

# later disabled it since users weren't able to sign up in production
# I'll have to keep tinkering with this!

class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

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
