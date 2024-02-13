import sys
import random

from pyspark import SparkContext, SparkConf


NUM_SAMPLES = 100000

def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1

def main():
    conf = SparkConf().setAppName("Calculate Pi")
    conf.set("fs.s3a.aws.credentials.provider", "ru.yandex.cloud.dataproc.s3.YandexMetadataCredentialsProvider")
    # conf.set("fs.defaultFS", "s3a://yc-dataproc-tasks/dataproc/hadoop")
    sc = SparkContext(conf=conf)
    job_id = dict(sc._conf.getAll())['spark.yarn.tags'].replace('dataproc_job_', '')

    count = sc.parallelize(range(0, NUM_SAMPLES)) \
                .filter(inside).count()
    
    # count.saveAsTextFile("s3a://yc-dataproc-tasks/output/jobs/" + job_id + ".txt")
    print(" ")
    print("-"*48)
    print("Pi is roughly %f" % (4.0 * count / NUM_SAMPLES))
    print("."*48)
    print(" ")

if __name__ == "__main__":
    main()
