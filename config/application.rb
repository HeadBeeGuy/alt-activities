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

    # The app previously used Sidekiq, but now that I've used up the AWS Free Tier,
    # ElastiCache will incur a monthly cost and it always seemed to be overkill
    # given the relatively modest server and db load thus far.
    # Configuration files are still lying around, but I'll deactivate ElastiCache
    # until we get to the point where background jobs seem necessary.
    # config.active_job.queue_adapter = :sidekiq
    
    config.time_zone = 'Asia/Tokyo'
  end
end
