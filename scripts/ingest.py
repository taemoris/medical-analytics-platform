import clickhouse_connect
import pandas as pd
from settings import ch_config

client = clickhouse_connect.get_client(
    host=ch_config.host,
    port=ch_config.port,
    username=ch_config.user,
    password=ch_config.password,
    database=ch_config.database,
)


def create_table_from_csv(csv_path: str, table_name: str) -> None:
    """Read header of CSV and create table ehr.<table_name> with all String columns"""
    header_df = pd.read_csv(csv_path, nrows=0)
    columns = header_df.columns.to_list()

    columns_ddl = ",\n    ".join(f"`{column}` String" for column in columns)
    ddl = f"""
    CREATE TABLE IF NOT EXISTS ehr.{table_name} (
        {columns_ddl},
        `_loaded_at` DateTime DEFAULT now(),
        `_source_file` String
    ) ENGINE = MergeTree
    ORDER BY tuple()
    """

    client.command(ddl)
    print(f"Created table ehr.{table_name} with {len(columns)} columns")
