up:
	docker compose up --build -d

down:
	docker compose down

build-nocache:
	docker compose build --no-cache

restart: down up

sh:
	docker exec -ti local-spark bash

meta:
	PGPASSWORD=sdepassword pgcli -h localhost -p 5435 -U sdeuser -d metadatadb

ddl: 
	docker exec -ti local-spark bash -c '$$SPARK_HOME/bin/spark-submit --master local[*] --packages io.delta:$${DELTA_PACKAGE_VERSION},org.apache.hadoop:hadoop-aws:3.3.2 --conf spark.databricks.delta.retentionDurationCheck.enabled=false --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.hadoop.fs.s3a.access.key=stockETL --conf spark.hadoop.fs.s3a.secret.key=stockETL --conf spark.hadoop.fs.s3a.endpoint=http://minio:9000 --conf spark.hadoop.fs.s3a.region=us-east-1 --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem --conf spark.hadoop.fs.s3a.path.style.access=true ./stockETL/delta_tables/create_bronze_layer.py'

stock-etl:
	docker exec -ti local-spark bash -c '$$SPARK_HOME/bin/spark-submit --packages io.delta:$${DELTA_PACKAGE_VERSION},org.apache.hadoop:hadoop-aws:3.3.2 --conf spark.databricks.delta.retentionDurationCheck.enabled=false --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.hadoop.fs.s3a.access.key=stockETL --conf spark.hadoop.fs.s3a.secret.key=stockETL --conf spark.hadoop.fs.s3a.endpoint=http://minio:9000 --conf spark.hadoop.fs.s3a.region=us-east-1 --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem --conf spark.hadoop.fs.s3a.path.style.access=true ./stockETL/pipelines/stock_etl.py'

spark-sql:
	docker exec -ti local-spark bash -c '$$SPARK_HOME/bin/spark-sql --packages io.delta:$${DELTA_PACKAGE_VERSION},org.apache.hadoop:hadoop-aws:3.3.2 --conf spark.hadoop.fs.s3a.access.key=stockETL --conf spark.hadoop.fs.s3a.secret.key=stockETL --conf spark.hadoop.fs.s3a.endpoint=http://minio:9000 --conf spark.hadoop.fs.s3a.region=us-east-1 --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem --conf spark.hadoop.fs.s3a.path.style.access=true --conf spark.databricks.delta.retentionDurationCheck.enabled=false --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog'

py-spark-sh:
	docker exec -ti local-spark bash -c '$$SPARK_HOME/bin/pyspark --packages io.delta:$${DELTA_PACKAGE_VERSION},org.apache.hadoop:hadoop-aws:3.3.2 --conf spark.hadoop.fs.s3a.access.key=stockETL --conf spark.hadoop.fs.s3a.secret.key=stockETL --conf spark.hadoop.fs.s3a.endpoint=http://minio:9000 --conf spark.hadoop.fs.s3a.region=us-east-1 --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem --conf spark.hadoop.fs.s3a.path.style.access=true --conf spark.databricks.delta.retentionDurationCheck.enabled=false --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog'


######################################################################################################

pytest:
	docker exec -ti local-spark bash -c 'python3 -m pytest --log-cli-level info -p no:warnings -v ./stockETL/tests'

format:
	docker exec -ti local-spark bash -c 'python3 -m black -S --line-length 79 --preview ./stockETL'
	docker exec -ti local-spark bash -c 'isort ./stockETL'

type:
	docker exec -ti local-spark bash -c 'python3 -m mypy --no-implicit-reexport --ignore-missing-imports --no-namespace-packages ./stockETL'

lint:
	docker exec -ti local-spark bash -c 'flake8 ./stockETL'
	docker exec -ti local-spark bash -c 'flake8 ./stockETL/tests'

ci: format type lint pytest