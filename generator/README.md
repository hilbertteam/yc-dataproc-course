# Приложение для генерации потоковых данных R7

## Локальный тест
```console
# Запуск локальной кафки
docker compose up -d
editor config.json
# Запуск приложения
npm start
# Просмотр содержимого топика с названием $TOPIC
docker exec -it redpanda-0 rpk topic consume $TOPIC --num 10
```

## Сборка контейнера
```
docker build . -t image
```

## Запуск
```console
# Создать конфиг со всеми параметрами
editor config.json
docker run -it --name generator --mount type=bind,source="$(pwd)"/config.json,target=/app/config.json image:latest
```

## Конфиг приложения

Конфиг имеет формат JSON и должен быть расположен рядом с приложением в файле `config.json`.

| Переменная | Описание | Пример |
| ---------- | -------- | ------ |
| KAFKA_BROKERS | FQDN брокеров кафки | [localhost:9200] |
| KAFKA_TOPIC | Название топика, куда нужно писать данные | transaction_data |
| KAFKA_USERNAME | (Опционально) Логин пользователя для доступа к брокеру | username |
| KAFKA_PASSWORD | (Опционально) Пароль пользователя для доступа к брокеру | pa$$w0rd |
| KAFKA_SSL_CA_CERT | (Опционально) Путь до сертификата при подключении к брокеру по SSL | /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt |
| TX_DELAY_MS | Задержка между сообщениями (в миллисекундах) при отправке сообщений в топик | 1000 |
| HOUSEHOLD_KEYS | Список уникальных идентификаторов домохозяйств | [1,2,3] |
| STORE_IDS | Список уникальных идентификаторов магазинов | [1,2] |
| PRODUCT_IDS | Список уникальных идентификаторов продуктов | [10, 50] |
| BASKET_ID | Начальный идентификатор корзины | 0 |
| DAY | Начальный день | 0 |
| AVG_TX_PER_DAY | Среднее число транзакций в день | 5 |
| QUANTITY | Диапазон, в котором выполняется генерация числа товаров transaction_data.QUANTITY | [1, 10] |
| SALES_VALUES | Диапазон, в котором выполняется генерация числа товаров transaction_data.SALES_VALUE | [5,10] |
| COUPON_MATCH_DISC | Диапазон, в котором выполняется генерация числа товаров transaction_data.COUPON_MATCH_DISC | [10, 50] |
| COUPON_DISC | Диапазон, в котором выполняется генерация числа товаров transaction_data.COUPON_DISC | [30, 50] |
| RETAIL_DISC | Диапазон, в котором выполняется генерация числа товаров transaction_data.RETAIL_DISC | [50, 70] |
