FROM ruby:2.3-slim

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  make \
  gcc \
  g++ \
  libxml2-dev \
  libxslt-dev \
  pkg-config \
  libcurl3-dev \
  libpq-dev \
  libgmp3-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

# Install gems
COPY Gemfile /app/
COPY Gemfile.lock /app/
WORKDIR /app
RUN echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle install --deployment --without development:test --jobs 3

# Env
ENV RAILS_ENV production
ENV RAILS_ROOT /app
ENV RACK_ENV production
ENV VIRTUAL_HOST *
ENV VIRTUAL_HOST_WEIGHT 0

# Copy project files
COPY . /app

# Setup application
RUN mkdir -p tmp/pids && \
  bundle exec rake assets:precompile && \
  ln -sf /dev/stdout /app/log/unicorn.log && \
  ln -sf /dev/stdout /app/log/production.log && \
  ln -sf /dev/stdout /app/log/resque.log

EXPOSE 3000
