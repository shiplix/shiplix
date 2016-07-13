FROM ubuntu:trusty

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  locales \
  make \
  gcc \
  g++ \
  curl \
  less \
  libxml2-dev \
  libxslt-dev \
  pkg-config \
  libcurl3-dev \
  libpq-dev \
  libgmp3-dev \
  postgresql-client-9.4 \
  git-core \
  ssh \
  libsqlite3-dev \
  ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

RUN locale-gen en_US.UTF-8 && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV RVM_PATH /usr/local/rvm
ENV RVM ${RVM_PATH}/bin/rvm
ENV RVM_RUBY ruby-2.3.1
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
  (\curl -ksSL https://get.rvm.io | bash -s stable)
RUN $RVM install $RVM_RUBY
ENV GEM_HOME /gems
ENV GEM_PATH ${GEM_HOME}
ENV PATH ${RVM_PATH}/rubies/${RVM_RUBY}/bin:${GEM_HOME}/bin:$PATH

RUN echo 'gem: --no-rdoc --no-ri --no-document' > /root/.gemrc && \
  ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts && \
  gem update --system && \
  gem install bundler && \
  bundle config --global build.nokogiri --use-system-libraries

COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN bundle install
