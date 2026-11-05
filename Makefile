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
PUBLICATIONS_BIB_PATH ?= assets/bibliographies/publications.bib
PUBLICATIONS_JSON_PATH ?= data/publications.json

# Controls
.PHONY : all commands build clean stop serve render render-site render-site-isolated shell publications-json standards-check deps-docsy deps-pack deps-lock deps-fonts
all : commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILE_COMMANDS} | sed -e 's/## //g'

## build            : build files but do not run a server.
build :
	$(DOCKER_COMPOSE) build --pull $(HUGO_SERVICE)

# A separate driver supports cache export on runners without containerd storage.
.PHONY: build-ci
## build-ci         : build once with an exportable Docker layer cache.
build-ci:
	docker buildx inspect omf-ci >/dev/null 2>&1 || docker buildx create --name omf-ci --driver docker-container --driver-opt default-load=true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.ci.yml build --builder omf-ci --pull $(HUGO_SERVICE)
	@# Replace the previous export so obsolete blobs do not accumulate.
	rm -rf .buildx-cache
	mv .buildx-cache-new .buildx-cache

## serve            : start and run a local server.
serve : build
	@$(DOCKER_COMPOSE) up -d --force-recreate --renew-anon-volumes $(HUGO_SERVICE)

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
		-e BUILD_TIMESTAMP_UTC \
		$(HUGO_SERVICE) -c '.github/scripts/build-site.sh'

## render-site-isolated : run production-style render in isolated container workspace with persistent cache.
render-site-isolated : build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) -e BASE_URL="$(RENDER_BASE_URL)" $(HUGO_SERVICE) -c 'sh .github/scripts/render-isolated.sh'

.PHONY: standards-test site-check html-check html-check-external check-tests
## standards-test   : test archive validation against damaged edition bundles.
standards-test:
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'python3 -B .github/scripts/test_standard_archives.py'

## site-check       : verify rendered navigation and downloads under a base path.
site-check: build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) -e BASE_URL=https://example.org/preview/ -e CHECK_SITE=1 $(HUGO_SERVICE) -c 'sh .github/scripts/render-isolated.sh'

## html-check       : run CI's pinned internal HTML checker in isolation.
html-check: build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) -e CHECK_HTML=1 $(HUGO_SERVICE) -c 'sh .github/scripts/render-isolated.sh'

## html-check-external : check external links separately from blocking checks.
html-check-external: build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) -e CHECK_HTML=external $(HUGO_SERVICE) -c 'sh .github/scripts/render-isolated.sh'

## check-tests      : test rendered-site diagnostics with disposable fixtures.
check-tests:
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'python3 -B .github/scripts/test_check_site.py'

## standards-check : verify preserved standard editions against their checksums.
standards-check:
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'python3 .github/scripts/check_standard_archives.py'

## publications-json: generate Hugo data/publications.json from BibTeX.
publications-json : build
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'uv run .github/scripts/bibtex_to_json.py --input "$(PUBLICATIONS_BIB_PATH)" --output "$(PUBLICATIONS_JSON_PATH)"'

## deps-docsy       : update the Docsy Hugo module; set DOCSY_VERSION=vX.Y.Z.
deps-docsy :
	@test -n "$(DOCSY_VERSION)" || { echo 'Set DOCSY_VERSION=vX.Y.Z'; exit 1; }
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'git config --global --add safe.directory /src && hugo mod get github.com/google/docsy/theme@$(DOCSY_VERSION)'

## deps-pack        : regenerate Hugo module npm workspace using the existing image.
deps-pack :
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'git config --global --add safe.directory /src && hugo mod npm pack'

## deps-lock        : update npm lockfile using the existing image.
deps-lock :
	$(HUGO_RUN_SH) $(HUGO_USER_ENV) $(HUGO_SERVICE) -c 'npm install --package-lock-only --ignore-scripts --no-audit --no-fund'

## deps-fonts       : regenerate pinned self-hosted fonts in the Hugo container.
deps-fonts :
	$(HUGO_RUN_SH) $(HUGO_SERVICE) -c 'apk add --no-cache bash curl openssl su-exec && su-exec "$(UID):$(GID)" env HOME=/tmp npm_config_cache=/tmp/.npm bash .github/scripts/download-fonts.sh'

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
