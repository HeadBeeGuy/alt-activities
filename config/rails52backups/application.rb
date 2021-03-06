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
    
    # the rails test suite bid me to add this line after upgrading to 5.2.0.rc2
    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true

		# apparently this is necessary if browsers don't support/run JavaScript for Ajax
		config.action_view.embed_authenticity_token_in_remote_forms = true

    # Sidekiq is nice and all, but after running the site for a while, it doesn't
    # look like background jobs are necessary yet.
    # config.active_job.queue_adapter = :sidekiq
    
    config.time_zone = 'Asia/Tokyo'
  end
end
