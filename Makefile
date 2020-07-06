default: cedar-14 heroku-16 heroku-18

VERSION := 2.7
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

# Download missing source archives to ./src/
src/gperftools-%.tar.gz:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/gperftools/gperftools/releases/download/gperftools-$*/gperftools-$*.tar.gz -o $@

.PHONY: cedar-14 heroku-16 heroku-18

# Build for cedar-14 stack
cedar-14: src/gperftools-$(VERSION).tar.gz
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/cedar:14 /wrk/build.sh $(VERSION) cedar-14

# Build for heroku-16 stack
heroku-16: src/gperftools-$(VERSION).tar.gz
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:16-build /wrk/build.sh $(VERSION) heroku-16

# Build for heroku-18 stack
heroku-18: src/gperftools-$(VERSION).tar.gz
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:18-build /wrk/build.sh $(VERSION) heroku-18

# Build recent releases for all supported stacks
all:
	$(MAKE) cedar-14 heroku-16 heroku-18 VERSION=2.7
	$(MAKE) cedar-14 heroku-16 heroku-18 VERSION=2.8
