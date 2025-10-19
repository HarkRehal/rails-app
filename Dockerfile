# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.9
FROM docker.io/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    nodejs \
    npm \
    libyaml-dev \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    libgmp-dev \
    libncurses5-dev \
    libffi-dev \
    libreadline6-dev

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
