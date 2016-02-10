FROM cloudgear/ruby:2.2

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  curl \
  libcurl3-dev \
  libpq-dev \
  time \
  libgmp3-dev && \
  rm -rf /var/lib/apt/lists/* && \
  truncate -s 0 /var/log/*log

# Install gems
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN cd /app && bundle install --quiet --deployment --without development test

# Project environment
ENV RAILS_ENV production
ENV RACK_ENV production
ENV UNICORN_ROOT /app

# Copy project files
COPY . /app

WORKDIR /app

# Setup application
RUN mkdir -p tmp/pids && \
  env $(cat /app/.env.sample | xargs) bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "unicorn", "-c", "/app/config/unicorn/production.rb", "-E", "deployment"]
