import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import avg, col, count, round, sum, to_date, unix_timestamp
from pyspark.sql.types import DecimalType

spark = SparkSession.builder.appName("build_mart_encounters_daily").getOrCreate()

jdbc_url = f"jdbc:clickhouse://clickhouse:8123/{os.getenv('CLICKHOUSE_DB', 'default')}"

jdbc_options = {
    "url": jdbc_url,
    "user": os.getenv("CLICKHOUSE_USER", "default"),
    "password": os.getenv("CLICKHOUSE_PASSWORD", ""),
    "driver": "com.clickhouse.jdbc.ClickHouseDriver",
}

query = """
SELECT
    encounter_id,
    toString(start_at) AS start_at,
    toString(stop_at) AS stop_at,
    patient_id,
    organization_id,
    provider_id,
    payer_id,
    encounter_class,
    code,
    description,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage,
    reason_code,
    reason_description
FROM stg_encounters
"""

df = (
    spark.read.format("jdbc")
    .options(**jdbc_options)
    .option("dbtable", f"({query}) AS t")
    .load()
)

df = df.filter(col("start_at") >= "2020-01-01")

df = (
    df.withColumn("date", to_date(col("start_at")))
    .groupBy(col("date"), col("encounter_class"))
    .agg(
        count(col("encounter_id")).alias("encounter_count"),
        avg(
            (unix_timestamp(col("stop_at")) - unix_timestamp(col("start_at"))) / 60
        ).alias("avg_duration_minutes"),
        sum(col("total_claim_cost")).alias("total_cost"),
        avg(col("total_claim_cost")).alias("avg_cost"),
    )
    .orderBy(col("date"), col("encounter_class"))
)


df_mart = df.select(
    col("date"),
    col("encounter_class"),
    col("encounter_count"),
    round(col("avg_duration_minutes"), 1).alias("avg_duration_minutes"),
    col("total_cost").cast(DecimalType(12, 2)).alias("total_cost"),
    col("avg_cost").cast(DecimalType(12, 2)).alias("avg_cost"),
)

(
    df_mart.write.format("jdbc")
    .options(**jdbc_options)
    .option("dbtable", "mart_encounters_daily")
    .partitionBy("date")
    .mode("append")
    .option("truncate", "true")
    .save()
)

spark.stop()
