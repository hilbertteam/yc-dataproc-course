import fs from "node:fs";
import { setTimeout as sleep } from "node:timers/promises";
import { Kafka, Partitioners, KafkaConfig } from "kafkajs";

function pick(array: number[]) {
  return array[Math.floor(Math.random() * array.length)];
}

function pickNumberFromInterval(interval: [number, number]) {
  const [min, max] = interval;
  return min + (max - min) * Math.random();
}

function round(n: number, fractionDigits: number) {
  return Number(n.toFixed(fractionDigits));
}

// Generate `count` numbers from `start` with delta `dt`
function uniformRange(start: number, dt: number, count: number) {
  return Array.from({ length: count }).map((_, i) => start + dt * i);
}

type Transaction = {
  householdKey: number;
  basketId: number;
  day: number;
  productId: number;
  quantity: number;
  salesValue: number;
  storeId: number;
  couponMatchDisc: number;
  couponDisc: number;
  retailDisc: number;
  transTime: number;
  weekNo: number;
};

class TransactionGenerator {
  private todayTransactionsCount: number = 0;
  private todayTransactionNumber: number = 0;
  private todayTransactionTimes: number[] = [];
  private weekNumber: number = 1;

  private static MAX_TIME = 2400;

  constructor(
    private params: {
      householdKeys: number[];
      storeIds: number[];
      productIds: number[];
      basketId: number;
      day: number;
      avgTxPerDay: number;
      quantity: [number, number];
      salesValue: [number, number];
      couponMatchDisc: [number, number];
      couponDisc: [number, number];
      retailDisc: [number, number];
    },
  ) {
    this.nextDay();
  }

  private nextDay() {
    const randPlusMinus1 = 2 * Math.random() - 1;
    // Generate uniform [a;b] from [-avg/2 + avg; avg + avg/2] -> mean is (a+b)/2 = 2avg / 2 = avg
    this.todayTransactionsCount = Math.max(
      0,
      Math.floor(
        (this.params.avgTxPerDay / 2) * randPlusMinus1 +
          this.params.avgTxPerDay,
      ),
    );
    this.todayTransactionNumber = 0;
    // Generate uniform distributed number of transaction for today but could be replaced with normal distribution if needed
    const dt = TransactionGenerator.MAX_TIME / this.todayTransactionsCount;
    this.todayTransactionTimes = uniformRange(
      0,
      dt,
      this.todayTransactionsCount,
    ).map((x) => Math.floor(x));
    this.params.day += 1;
    // Week number according to data sample starts from 1
    this.weekNumber = Math.floor(this.params.day / 7) + 1;
  }

  next(): Transaction {
    if (this.todayTransactionsCount === this.todayTransactionNumber) {
      this.nextDay();
    }
    const transactionData = {
      householdKey: pick(this.params.householdKeys),
      basketId: this.params.basketId,
      day: this.params.day,
      productId: pick(this.params.productIds),
      quantity: Math.floor(pickNumberFromInterval(this.params.quantity)),
      salesValue: round(pickNumberFromInterval(this.params.salesValue), 2),
      storeId: pick(this.params.storeIds),
      couponMatchDisc: round(
        pickNumberFromInterval(this.params.couponMatchDisc),
        2,
      ),
      couponDisc: round(pickNumberFromInterval(this.params.couponDisc), 2),
      retailDisc: round(pickNumberFromInterval(this.params.retailDisc), 2),
      transTime: this.todayTransactionTimes[this.todayTransactionNumber],
      weekNo: this.weekNumber,
    };
    this.params.basketId += 1;
    this.todayTransactionNumber += 1;
    return transactionData;
  }
}

function readConfigFromFile(path = "./config.json") {
  return JSON.parse(fs.readFileSync(path, "utf-8"));
}

function serializeTransaction(transaction: Transaction) {
  return JSON.stringify({
    HOUSEHOLD_KEY: transaction.householdKey,
    BASKET_ID: transaction.basketId,
    DAY: transaction.day,
    PRODUCT_ID: transaction.productId,
    QUANTITY: transaction.quantity,
    SALES_VALUE: transaction.salesValue,
    STORE_ID: transaction.storeId,
    COUPON_MATCH_DISC: transaction.couponMatchDisc,
    COUPON_DISC: transaction.couponDisc,
    RETAIL_DISC: transaction.retailDisc,
    TRANS_TIME: transaction.transTime,
    WEEK_NO: transaction.weekNo,
  });
}

async function main() {
  const config = readConfigFromFile();
  const generator = new TransactionGenerator({
    householdKeys: config.HOUSEHOLD_KEYS,
    storeIds: config.STORE_IDS,
    productIds: config.PRODUCT_IDS,
    basketId: config.BASKET_ID,
    day: config.DAY,
    avgTxPerDay: config.AVG_TX_PER_DAY,
    quantity: config.QUANTITY,
    salesValue: config.SALES_VALUE,
    couponMatchDisc: config.COUPON_MATCH_DISC,
    couponDisc: config.COUPON_DISC,
    retailDisc: config.RETAIL_DISC,
  });

  const kafkaConfig: KafkaConfig = {
    brokers: config.KAFKA_BROKERS,
  };
  if (config.KAFKA_USERNAME) {
    kafkaConfig.sasl = {
      mechanism: "scram-sha-512",
      username: config.KAFKA_USERNAME,
      password: config.KAFKA_PASSWORD,
    };
  }
  if (config.KAFKA_SSL_CA_CERT) {
    kafkaConfig.ssl = {
      ca: [fs.readFileSync(config.KAFKA_SSL_CA_CERT, "utf-8")],
    };
  }
  const kafka = new Kafka(kafkaConfig);
  const producer = kafka.producer({
    createPartitioner: Partitioners.DefaultPartitioner,
  });
  await producer.connect();
  console.log("Connected");
  while (true) {
    const transaction = generator.next();
    console.log("produce", transaction);
    await producer.send({
      topic: config.KAFKA_TOPIC,
      messages: [
        {
          value: serializeTransaction(transaction),
        },
      ],
    });
    await sleep(+config.TX_DELAY_MS);
  }
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
