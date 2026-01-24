ARG HUGO_VERSION=0.154.5
ARG DIST_TAG=-ext-ubuntu
FROM floryn90/hugo:${HUGO_VERSION}${DIST_TAG}

ARG DOCSY_VERSION=v0.13.0

LABEL maintainer="CoMSES Net <support@comses.net>"

RUN git config --global --add safe.directory /src

USER root
CMD ["server"]
