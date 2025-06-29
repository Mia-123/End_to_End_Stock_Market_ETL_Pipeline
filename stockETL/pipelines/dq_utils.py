from soda.scan import Scan
from pyspark.sql import SparkSession


def spark_scan(
        df,
        spark,
        soda_check_name,
        soda_variables = {},
        root_dir: str='/opt/spark/work-dir/stockETL/data_quality',
):
    df.createOrReplaceTempView(soda_check_name)

    scan = Scan()
    scan.set_verbose(True)
    scan.set_scan_definition_name(soda_check_name)
    scan.set_data_source_name(soda_check_name)
    scan.add_spark_session(spark, data_source_name=soda_check_name)
    if soda_variables:
        scan.add_variables(soda_variables)
    scan.add_sodacl_yaml_file(file_path=f"{root_dir}/{soda_check_name}.yml")

    scan.execute()
    scan_results = scan.get_scan_results()

    print("--------------logs--------------")
    print(scan.get_logs_text())
    print('------ End of data validation results -----')