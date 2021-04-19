FROM ruby:2.7-slim-buster
RUN apt-get update -qq && apt-get install -y postgresql-client \
    libpq-dev \
    curl \
    build-essential
RUN mkdir /alt-activities
WORKDIR /alt-activities
COPY Gemfile Gemfile.lock /alt-activities/
RUN gem install bundler && bundle install --jobs 20 --retry 5
COPY . /alt-activities

RUN apt-get update && \
    apt-get install apt-transport-https && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y vim && \
    npm install -g yarn && \
    yarn install --check-files && \
    apt-get clean all

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN bundle exec rake assets:precompile

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD ["rails", "server"]
