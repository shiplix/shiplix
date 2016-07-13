RAILS_ENV = test
BUNDLE = RAILS_ENV=${RAILS_ENV} bundle

all: test

test: setup
	${BUNDLE} exec rspec

setup:
	${BUNDLE} install -j 2
	${BUNDLE} exec rake db:structure:load
	${BUNDLE} exec rake db:migrate
