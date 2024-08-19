from pyspark.sql import SparkSession
import getpass

# JDBC driver path for SQL Server
jdbc_driver_path = "ETL/mssql-jdbc-12.8.0.jre8.jar"

# Create a spark session
spark = SparkSession.builder \
    .appName("ExtractData") \
    .config("spark.jars", jdbc_driver_path) \
    .getOrCreate()

sqlEngine = 'jdbc'
sqlServer = 'sqlserver'
sqlUser = 'sa'
sqlPassword = getpass.getpass("Enter your SQL server password: ")
sqlHost = 'localhost'
sqlPort = '1433'
sqlDB_name = 'LogCDCDatabase'

db_connection_string = f"{sqlEngine}:{sqlServer}://{sqlHost};databaseName={sqlDB_name};encrypt=true;trustServerCertificate=true;"

connectionProperties = {
    "user": sqlUser,
    "password": sqlPassword,
    "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver"
}

# Get all the tables that cdc is enabled on
tablesCDCisEnabled = "SELECT t.name as table_name, ct.capture_instance \
    FROM sys.tables t \
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id \
    INNER JOIN cdc.change_tables ct ON t.object_id = ct.object_id"

# Put all the tables that cdc is enabled on into a pyspark dataframe
cdc_tables_df = spark.read.jdbc(url=db_connection_string, table=f"({tablesCDCisEnabled}) AS cdc_tables", properties=connectionProperties)

# Show the datafrane created
cdc_tables_df.show()

# Iterate over CDC-enabled tables and export data to Parquet
for row in cdc_tables_df.collect():
    schema_name = 'dbo' # Default schema name
    table_name = row['table_name']
    capture_instance = row['capture_instance']
    
    cdc_table_name = f"[cdc].[{table_name}]"
    cdc_data_query = f"SELECT * FROM {cdc_table_name}"
    cdc_data_df = spark.read.jdbc(url=db_connection_string, table=f"({cdc_data_query}) AS cdc_data", properties=connectionProperties)

    output_path = f"PullingPort/{capture_instance}_cdc.parquet"
    
    cdc_data_df.write.parquet(output_path, mode='overwrite')

    print(f"Exported CDC data for table {capture_instance} to {output_path}")

