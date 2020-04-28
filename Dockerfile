FROM klakegg/hugo:0.69.2-ext-nodejs

COPY package.json yarn.lock /src/

RUN yarn install
