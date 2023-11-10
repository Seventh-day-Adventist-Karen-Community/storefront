FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./

ENV CI 1
RUN npm i
# RUN npm ci --legacy-peer-deps

COPY nginx/ nginx/

COPY src/ src/

ARG API_URI
ARG SKIP_SOURCEMAPS

ENV API_URI ${API_URI:-http://vps.sdackc.org:8009/graphql/}
ENV SKIP_SOURCEMAPS ${SKIP_SOURCEMAPS:-true}
RUN npm run build

FROM nginx:stable-alpine as runner
WORKDIR /app

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/replace-api-url.sh /docker-entrypoint.d/50-replace-api-url.sh
COPY --from=builder /app/build/ /app/

