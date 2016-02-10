FROM ubuntu:trusty

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  curl \
  libcurl3-dev \
  libpq-dev \
  time \
  libgmp3-dev && \
  rm -rf /var/lib/apt/lists/*

# Setup User
RUN useradd --home /home/worker -M worker -K UID_MIN=1000 -K GID_MIN=1000 -s /bin/bash && \
  mkdir /home/worker && \
  chown worker:worker /home/worker && \
  adduser worker sudo && \
  echo 'worker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER worker
WORKDIR /home/worker

# Install RVM
RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c 'source ~/.rvm/scripts/rvm'

# Install Ruby
RUN /bin/bash -l -c 'rvm requirements && rvm install 2.3.0'
RUN echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> /home/worker/.bashrc

# Install gems
ADD Gemfile /home/worker/shiplix/
ADD Gemfile.lock /home/worker/shiplix/
RUN /bin/bash -l -c 'rvm use 2.3.0 --default && \
  echo "gem: --no-rdoc --no-ri" >> /home/worker/.gemrc && \
  gem install bundler -v 1.11.2 && \
  sudo chown -R worker:worker /home/worker/shiplix && \
  cd /home/worker/shiplix && \
  bundle install --quiet --deployment --without development test'

# Project environment
ENV RAILS_ENV production
ENV UNICORN_ROOT /home/worker/shiplix

# Copy project files
ADD . /home/worker/shiplix
RUN sudo chown -R worker:worker /home/worker/shiplix

WORKDIR /home/worker/shiplix

RUN mkdir -p tmp/pids

EXPOSE 3000
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "unicorn", "-c", "/home/worker/shiplix/config/unicorn/production.rb", "-E", "deployment"]
