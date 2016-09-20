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
$ ./docker/bin/compose build
$ ./docker/bin/bundle install
$ ./docker/bin/bundle exec rake db:create
$ ./docker/bin/bundle exec rake db:migrate
$ RAILS_ENV=test ./docker/bin/bundle exec rake db:migrate
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

#### Configure

TODO

#### Deploy

TODO
