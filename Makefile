## ========================================
## Commands for building and testing OMF website deployment
## ========================================

# Settings
MAKEFILE_COMMANDS=Makefile $(wildcard *.mk)
UID=$(shell id -u)
GID=$(shell id -g)
DOCKER_COMPOSE=docker compose
HUGO_SERVICE=hugo
HUGO_RUN_SH=$(DOCKER_COMPOSE) run --rm --no-deps --entrypoint sh
HUGO_CACHE_CONTAINER_DIR ?= /src/.hugo_cache
RENDER_OUTPUT_DIR ?= /src/public
RENDER_BASE_URL ?=
HUGO_USER_ENV=--user "$(UID):$(GID)" -e HOME=/tmp -e npm_config_cache=/tmp/.npm

# Controls
.PHONY : all commands build clean stop serve render render-site shell
all : commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILE_COMMANDS} | sed -e 's/## //g'

## build            : build files but do not run a server.
build :
	$(DOCKER_COMPOSE) build --pull $(HUGO_SERVICE)

## serve            : start and run a local server.
serve : build
	@$(DOCKER_COMPOSE) up -d $(HUGO_SERVICE)

## render           : run the production-style site render locally.
render :
	$(HUGO_RUN_SH) $(HUGO_SERVICE) -c 'rm -f /src/.hugo_build.lock && rm -rf /src/public /src/resources/_gen'
	$(MAKE) render-site

## render-site      : run the shared production build script in the container.
render-site : build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) \
		-e HUGO_CACHEDIR="$(HUGO_CACHE_CONTAINER_DIR)" \
		-e OUTPUT_DIR="$(RENDER_OUTPUT_DIR)" \
		-e BASE_URL="$(RENDER_BASE_URL)" \
		$(HUGO_SERVICE) -c '.github/scripts/build-site.sh'

## shell            : open a hugo shell
shell : build
	$(DOCKER_COMPOSE) run --rm --no-deps $(HUGO_SERVICE) shell

## stop             : stop the docker server and clean up
stop :
	$(DOCKER_COMPOSE) down -v

## clean            : clean up junk files.
clean :
	@rm -rf ./resources/_gen
	@find . \( -name .DS_Store -o -name '*~' \) -print -exec rm {} +
