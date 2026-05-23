# syntax=docker/dockerfile:1.7

ARG HUGO_VERSION=v0.161.1
ARG UV_VERSION=0.11.16
ARG BIBTEX_VERSION=2.0.0b9

# Stage 1: preprocess BibTeX into Hugo data.
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM python:3.12-alpine AS bibtex-builder
COPY --from=uv /uv /uvx /bin/
ARG BIBTEX_VERSION

WORKDIR /work

# Only copy what the preprocessing step needs.
COPY assets/bibliographies/publications.bib ./publications.bib
COPY .github/scripts/bibtex_to_json.py ./scripts/bibtex_to_json.py

RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system --break-system-packages "bibtexparser>=${BIBTEX_VERSION}"

RUN mkdir -p ./data && \
    python ./scripts/bibtex_to_json.py \
      --input ./publications.bib \
      --output ./data/publications.json

# Stage 2: local dev Hugo server.
FROM ghcr.io/gohugoio/hugo:${HUGO_VERSION}
COPY --from=uv /uv /uvx /bin/

ARG BIBTEX_VERSION
LABEL maintainer="CoMSES Net <support@comses.net>"

USER root

RUN git config --global --add safe.directory /src

# Install Node.js/npm for PostCSS, Go, and Python for repo maintenance scripts.
RUN apk add --no-cache nodejs npm go python3

# Install Python dependencies used by repository scripts.
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system --break-system-packages "bibtexparser>=${BIBTEX_VERSION}"

# Install front-end tooling.
COPY package.json package-lock.json /tmp/
RUN --mount=type=cache,target=/root/.npm \
    cd /tmp && npm ci

ENV PATH="/tmp/node_modules/.bin:${PATH}"

WORKDIR /src

# Copy the site source after dependency installation for better layer reuse.
COPY . .

# Overwrite any checked-in data file with the generated one.
RUN mkdir -p /src/data
COPY --from=bibtex-builder /work/data/publications.json /src/data/publications.json

CMD ["server", "--bind", "0.0.0.0"]