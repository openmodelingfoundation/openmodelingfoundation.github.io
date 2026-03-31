## ========================================
## Commands for building and testing OMF website deployment
## ========================================

# Settings
MAKEFILES=Makefile $(wildcard *.mk)
UID=$(shell id -u)
GID=$(shell id -g)
DOCKER_COMPOSE=docker compose
HUGO_RUN_SH=$(DOCKER_COMPOSE) run --rm --no-deps --entrypoint sh
HUGO_USER_ENV=--user "$(UID):$(GID)" -e HOME=/tmp -e npm_config_cache=/tmp/.npm -e HUGO_CACHEDIR=/src/.hugo_cache

# Controls
.PHONY : all commands build clean stop serve render shell
all : commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILES} | sed -e 's/## //g'

## build            : build files but do not run a server.
build :
	$(DOCKER_COMPOSE) build --pull

## serve            : start and run a local server.
serve : build
	@$(DOCKER_COMPOSE) up -d

## render           : run the production-style site render locally.
render : build
	$(HUGO_RUN_SH) hugo -c 'rm -f /src/.hugo_build.lock && rm -rf /src/public /src/resources/_gen'
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) hugo -c '.github/scripts/build-site.sh'

## shell            : open a hugo shell
shell : build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) hugo

## stop             : stop the docker server and clean up
stop :
	$(DOCKER_COMPOSE) down -v

## clean            : clean up junk files.
clean :
	@rm -rf ./resources/_gen
	@find . \( -name .DS_Store -o -name '*~' \) -print -exec rm {} +
