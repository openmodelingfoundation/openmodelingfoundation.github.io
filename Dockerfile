ARG HUGO_VERSION=0.133.1
ARG DIST_TAG=-ext-ubuntu
FROM floryn90/hugo:${HUGO_VERSION}${DIST_TAG}

ARG DOCSY_VERSION=v0.11.0

LABEL maintainer="CoMSES Net <support@comses.net>"

WORKDIR /src
COPY . /src/

RUN git config --global --add safe.directory /src

RUN hugo mod get
RUN npm install

CMD ["server"]
