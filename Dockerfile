FROM ruby:2.6-alpine
RUN apk add --update build-base postgresql-dev tzdata bash
WORKDIR /alt-activities
ADD Gemfile Gemfile.lock /alt-activities/
RUN gem install bundler
COPY . /alt-activities


RUN apk add --update --no-cache \
    nodejs \
    postgresql-dev \
    yarn \
    && rm -rf /var/cache/apk/*

RUN bundle install --jobs 20 --retry 2

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Command doesn't work in Alpine - says it can't find Ruby
# Development and Test environments still function, but will Production?
# RUN bundle exec rake assets:precompile

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD ["rails", "server"]
