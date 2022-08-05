ARG HUGO_VERSION=0.101.0
ARG DIST_TAG=-ext-ubuntu
FROM klakegg/hugo:${HUGO_VERSION}${DIST_TAG}

LABEL maintainer="CoMSES Net <support@comses.net>"

WORKDIR /src
COPY ./package.json ./yarn.lock /src/

RUN yarn install

CMD ["server"]
