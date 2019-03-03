source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.2'
gem 'railties'
gem 'puma'
gem 'bootsnap'
gem 'listen'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# haven't needed to use it yet
#gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'haml' # personally I find haml much easier to write than ERB
gem 'rails-controller-testing'
gem 'bootstrap', '~> 4.3.1'
gem 'devise'
gem 'pundit'
gem 'redcarpet' # for rendering Markdown in HTML
gem 'aws-sdk-s3', require: false
gem 'kaminari' # for pagination
gem 'sidekiq' # the Rails background job solution of choice, it would appear!
gem 'pg', '1.0.0' # all PostGres all the time!
gem 'rack', '~> 2.0.6' # GitHub security advisory
gem 'recaptcha'

# not quite sure what gem included this one, but GitHub notified me of a vulnerability in 2.1.1
gem 'loofah', '~> 2.2.3'

# 1.8.3 broke deployment with Elastic Beanstalk, so I'll try 1.8.2 for now
# all newer versions of nokogiri seem to break EB deployment, which is frustrating!
gem 'nokogiri', '1.8.2'
# someone on StackOverflow said this helped their deployment issue with autoprefixer
# https://stackoverflow.com/a/51991302
gem 'mini_racer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  
  # vestigial now, but I'm a bit afraid that removing it will break something
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
	gem 'faker'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  # gem 'pg', '~> 0.20' # now vestigial
end

