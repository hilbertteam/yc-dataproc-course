FROM node:23-alpine

WORKDIR /app

ENV TX_DELAY_MS=1000

RUN mkdir -p /usr/local/share/ca-certificates/Yandex && \
  wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
  --output-document /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt && \
  chmod 0655 /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt && apk add --no-cache gettext

COPY . .

RUN npm ci

ENTRYPOINT ["sh", "-c", "envsubst < /app/config-template.json > /app/config.json && exec \"$@\"", "--"]

CMD ["npm", "start"]
