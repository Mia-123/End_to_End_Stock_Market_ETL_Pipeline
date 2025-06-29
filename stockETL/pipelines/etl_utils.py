import os
from abc import ABC, abstractmethod
from typing import Dict, List, Optional
from delta.tables import DeltaTable
from pyspark.sql import DataFrame, SparkSession
from datetime import datetime
from pyspark.sql.functions import col, current_timestamp, expr, lit, to_date, monotonically_increasing_id, to_timestamp
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType, TimestampType
import json
from soda.scan import Scan

def ingest_data_to_delta(
    load_df,
    table_name: str,
    mode='append',
    storage_path='s3a://stockETL/delta'):
    # Write DataFrame to Delta format
    delta_output_path = f"{storage_path}/{table_name}"
    load_df.write.format('delta').mode(mode).save(delta_output_path)
    print(f"data ingested to delta table: {delta_output_path}")


def read_data_from_delta(
    table_name: str,
    spark: SparkSession,
    filter_confition: str=None,
    storage_path='s3a://stockETL/delta'
    ):
   pass


def deduplication(table_name: str, spark: SparkSession, filter_condition: str=None, storage_path='s3a://stockETL/delta'):
    pass


def run_data_validations(
        df,
        data_asset_name: str,
        root_dir: str='/opt/spark/work-dir/stockETL/data_quality',
    ):
    pass
    
    
def setup_spark_session():
    spark = SparkSession.builder \
    .appName("stockETL") \
    .master('local[*]') \
    .config("spark.jars.packages", "io.delta:delta-core_2.12:2.3.0,org.apache.hadoop:hadoop-aws:3.3.2") \
    .config("spark.databricks.delta.retentionDurationCheck.enabled", "false") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .config("spark.hadoop.fs.s3a.access.key", "stockETL") \
    .config("spark.hadoop.fs.s3a.secret.key", "stockETL") \
    .config("spark.hadoop.fs.s3a.endpoint", "http://minio:9000") \
    .config("spark.hadoop.fs.s3a.region", "us-east-1") \
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
    .config("spark.hadoop.fs.s3a.path.style.access", "true") \
    .enableHiveSupport() \
    .getOrCreate()
    return spark