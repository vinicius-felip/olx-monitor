# syntax=docker/dockerfile:1.2

ARG NODE_VERSION=18.20.4
FROM node:${NODE_VERSION}-alpine as base

RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    nasm \
    bash \
    vips-dev \
    libc6-compat

WORKDIR /usr/src/app
EXPOSE 3000

RUN chown -R node:node /usr/src/app

FROM base as dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
COPY --chown=node:node ./package.json ./package-lock.json ./
RUN npm ci --only=production
COPY --chown=node:node . .
ENV PATH /usr/src/app/node_modules/.bin:/usr/src/app/node_modules/cycletls/dist:$PATH
USER node
CMD ["npm", "run", "start"]