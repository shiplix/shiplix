# Shiplix

Awesome code analyze tool for Ruby projects

## Usage

#### Show Resque statistics

`http://test.shiplix.com/resque_web`

## Installation

### Development

#### Docker
```
$ cp .env.sample .env
$ vi .env
$ docker-compose build
$ docker-compose run --rm app bundle install
$ docker-compose run --rm app bundle exec rake db:create
$ docker-compose run --rm app bundle exec rake db:migrate
$ docker-compose run --rm -e RAILS_ENV=test app bundle exec rake db:migrate
$ docker-compose up -d
```

#### Ansible

Install ansible on host machine.

```
cd cm && make ansible/install_roles && cd ..
vagrant up
```

Then login to you new virtual machine with `vagrunt ssh` and configure project with `./bin/setup` command

### Production

#### Install

http://kontena.io/docs/getting-started/installing/

```
$ gem install kontena-cli
$ kontena login http://kontena.shiplix.com:8080
$ kontena grid create staging
```

#### Build

Build image and push to https://hub.docker.com/r/shiplix

```
$ kontena app build
```

#### Deploy

```
$ kontena app deploy
```
