FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y postgresql-client
RUN mkdir /alt-activities
WORKDIR /alt-activities
COPY Gemfile /alt-activities/Gemfile
COPY Gemfile.lock /alt-activities/Gemfile.lock
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

RUN rake assets:precompile

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["rails", "server"]
