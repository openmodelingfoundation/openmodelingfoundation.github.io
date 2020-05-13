FROM klakegg/hugo:0.69.2-ext-nodejs

WORKDIR /src
COPY ./package.json ./yarn.lock /src/

RUN yarn install

CMD ["server"]
