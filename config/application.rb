require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    # Rails 6 changed ActiveStorage to replace all attachments by default when editing
    # In Rails 6.0 this line may not be necessary given that I'm specifying the defaults
    # from 5.0 above, but it sounds like this may change again with 6.1 and beyond
    config.active_storage.replace_on_assign_to_many = false

		# apparently this is necessary if browsers don't support/run JavaScript for Ajax
		config.action_view.embed_authenticity_token_in_remote_forms = true
    
    config.time_zone = 'Asia/Tokyo'
  end
end
