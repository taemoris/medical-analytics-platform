import os

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("read_clickhouse").getOrCreate()

jdbc_url = f"jdbc:clickhouse://clickhouse:8123/{os.getenv('CLICKHOUSE_DB', 'default')}"

df = (
    spark.read.format("jdbc")
    .option("url", jdbc_url)
    .option("driver", "com.clickhouse.jdbc.ClickHouseDriver")
    .option("dbtable", "raw_encounters")
    .option("user", os.getenv("CLICKHOUSE_USER", "default"))
    .option("password", os.getenv("CLICKHOUSE_PASSWORD", ""))
    .load()
)

print(df.count())
df.printSchema()
df.show(5, truncate=False)

spark.stop()