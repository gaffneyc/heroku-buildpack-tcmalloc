default: heroku-18

VERSION := 2.9.1
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

# Download missing source archives to ./src/
src/gperftools-%.tar.gz:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/gperftools/gperftools/releases/download/gperftools-$*/gperftools-$*.tar.gz -o $@

.PHONY: heroku-18

# Build for heroku-18 stack
heroku-18: src/gperftools-$(VERSION).tar.gz
	docker pull heroku/heroku:18-build
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:18-build /wrk/build.sh $(VERSION) heroku-18

# Build for heroku-20 stack
heroku-20: src/gperftools-$(VERSION).tar.gz
	docker pull heroku/heroku:20-build
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:20-build /wrk/build.sh $(VERSION) heroku-20

# Build recent releases for all supported stacks
all:
	$(MAKE) heroku-18 VERSION=2.7
	$(MAKE) heroku-18 VERSION=2.8
