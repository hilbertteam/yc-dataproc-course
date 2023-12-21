FROM node:alpine

WORKDIR /app

RUN mkdir -p /usr/local/share/ca-certificates/Yandex && \
  wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
  --output-document /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt && \
  chmod 0655 /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt

COPY . .

RUN npm ci

CMD ["npm", "start"]
