FROM ruby:2.6.2

# Add node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Add Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Install Main Items
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Install Yarn
RUN apt-get install yarn -y

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler:2.0.2 && bundle install --jobs 20 --retry 5
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]