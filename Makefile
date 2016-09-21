BUNDLER_VERSION = 1.13.1
RAILS_ENV ?= development
BUNDLE = ./docker/bin/bundle
COMPOSE = ./docker/bin/compose
RUN_CMD = ${COMPOSE} run --rm web

test:
	RAILS_ENV=test ${BUNDLE} exec rspec

setup:
	docker volume ls -q | grep gems-ruby2 > /dev/null || docker volume create --name gems-ruby2
	${COMPOSE} build
	${RUN_CMD} gem install bundler --no-ri --no-rdoc --version=${BUNDLER_VERSION}
	${BUNDLE} install -j 5 ${GEMS_INSTALL_ARGS}
	${BUNDLE} exec rake db:structure:load db:migrate --trace

down:
	${COMPOSE} down

server:
	./docker/bin/web

console:
	./docker/bin/rails c
