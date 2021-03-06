source 'https://rubygems.org'

ruby '~> 2.6'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.3'
gem 'railties'
gem 'puma', '>= 4.3.5'
# gem 'bootsnap'
gem 'listen'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'haml' # personally I find haml much easier to write than ERB
gem 'rails-controller-testing'
gem 'bootstrap', '~> 4.4.1'
gem 'devise'
gem 'pundit'
gem 'redcarpet' # for rendering Markdown in HTML
gem 'aws-sdk-s3', require: false
gem 'kaminari', '>= 1.2.1'  # for pagination
gem 'pg', '1.2.2'
gem 'rack', '>= 2.2.3'
gem 'recaptcha'
gem 'loofah', '>= 2.4.0'
gem 'nokogiri', '>= 1.11.0.rc4'
gem 'pg_search'
gem 'webpacker'

# someone on StackOverflow said this helped their deployment issue with autoprefixer
# https://stackoverflow.com/a/51991302
# may no longer be necessary?
gem 'mini_racer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '>= 0.4.0', group: :doc

# GitHub told me to update these gems
gem "websocket-extensions", ">= 0.1.5"
gem "json", ">= 2.3.0"

group :development, :test do
  gem 'byebug'
  gem 'rb-readline'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
	gem 'faker'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

