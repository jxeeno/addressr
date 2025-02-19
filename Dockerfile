ARG BASE_IMAGE=node:16.3.0-alpine3.13
FROM ${BASE_IMAGE}

RUN apk add --no-cache \
    dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ENV ELASTIC_PORT="9200"
ENV ELASTIC_HOST="host.docker.internal"
ENV ELASTIC_USERNAME=
ENV ELASTIC_PASSWORD=
ENV ELASTIC_PROTOCOL=

ENV ADDRESSR_INDEX_TIMEOUT="30s"
ENV ADDRESSR_INDEX_BACKOFF="1000"
ENV ADDRESSR_INDEX_BACKOFF_INCREMENT="1000"
ENV ADDRESSR_INDEX_BACKOFF_MAX="10000"

WORKDIR "/home/${USER}"

COPY package.json package.json
COPY package-lock.json package-lock.json
COPY scripts/check-version.js scripts/check-version.js

RUN npm install

COPY . .
RUN npm run build

CMD ["node", "lib/bin/addressr-server-2.js"]
