# syntax=docker/dockerfile:1.7

ARG HUGO_VERSION=v0.166.0
ARG UV_VERSION=0.12.5

# Stage 1: preprocess BibTeX into Hugo data.
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM python:3.12-alpine AS bibtex-builder
COPY --from=uv /uv /uvx /bin/

WORKDIR /work

# Only copy what the preprocessing step needs.
COPY assets/bibliographies/publications.bib ./publications.bib
COPY .github/scripts/bibtex_to_json.py ./scripts/bibtex_to_json.py

RUN --mount=type=cache,target=/root/.cache/uv \
    mkdir -p ./data && \
    uv run ./scripts/bibtex_to_json.py \
      --input ./publications.bib \
      --output ./data/publications.json

# Stage 2: local dev Hugo server.
FROM ghcr.io/gohugoio/hugo:${HUGO_VERSION}
COPY --from=uv /uv /uvx /bin/

LABEL maintainer="CoMSES Net <support@comses.net>"

USER root

RUN git config --global --add safe.directory /src

# Install Node.js/npm for PostCSS, Go, and Python for repo maintenance scripts.
# python3 is required for uv to create a venv when running scripts with inline metadata.
RUN apk add --no-cache nodejs npm go python3

# Install front-end tooling and Docsy theme npm dependencies into
# /tmp/node_modules. The packages/ directory contains Hugo's generated npm
# workspace, which npm ci requires because package.json lists it as a workspace.
COPY package.json package-lock.json /tmp/
COPY packages/ /tmp/packages/
RUN --mount=type=cache,target=/root/.npm \
    cd /tmp && npm ci

# The sass-embedded package provides the native Dart Sass binary that Hugo's
# TOCSS-DART needs (via the embedded Sass protocol).  The pure-JS sass package
# is also installed as a transitive dependency of sass-embedded's fallback
# platform packages, and npm resolves the .bin/sass symlink to it instead of
# to sass-embedded.  Fix the symlink so Hugo uses the embedded Dart Sass.
RUN chmod +x /tmp/node_modules/sass-embedded/dist/bin/sass.js && \
    ln -sf ../sass-embedded/dist/bin/sass.js /tmp/node_modules/.bin/sass

ENV PATH="/tmp/node_modules/.bin:${PATH}"

WORKDIR /src

# Copy the site source after dependency installation for better layer reuse.
COPY . .

# Overwrite any checked-in data file with the generated one.
RUN mkdir -p /src/data
COPY --from=bibtex-builder /work/data/publications.json /src/data/publications.json

CMD ["server", "--bind", "0.0.0.0"]