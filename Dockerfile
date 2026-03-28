ARG HUGO_VERSION=v0.159.1
FROM ghcr.io/gohugoio/hugo:${HUGO_VERSION}

ARG DOCSY_VERSION=v0.14.3

LABEL maintainer="CoMSES Net <support@comses.net>"

USER root

RUN git config --global --add safe.directory /src

# Install Node.js and npm for PostCSS (required by Docsy)
RUN apk add --no-cache nodejs npm

# Install front-end tooling.
# Layer is invalidated only when package.json or package-lock.json changes.
# The BuildKit cache mount keeps the npm download cache across rebuilds so
# packages are never re-fetched from the network unnecessarily.
COPY package.json package-lock.json /tmp/
RUN --mount=type=cache,target=/root/.npm \
    cd /tmp && npm ci

ENV PATH="/tmp/node_modules/.bin:${PATH}"

CMD ["server", "--bind", "0.0.0.0"]
