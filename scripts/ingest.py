import logging
from pathlib import Path

import clickhouse_connect
import pandas as pd
from settings import ch_config

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s"
)
logger = logging.getLogger(__name__)

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


def load_data_to_csv(csv_path: str, table_name: str) -> int:
    """Load csv into ehr.<table_name>, return number of rows inserted"""
    df = pd.read_csv(csv_path, dtype=str, keep_default_na=False)

    df["_loaded_at"] = pd.Timestamp.now()
    df["_source_file"] = Path(csv_path).name

    client.insert_df(df=df, table=table_name, database=ch_config.database)
    return len(df)


def main():
    data_dir = Path("data/raw/synthea")
    csv_files = sorted(data_dir.glob("*.csv"))
    logger.info("Found %d CSV files in %s", len(csv_files), data_dir)

    for csv_path in csv_files:
        table_name = f"raw_{csv_path.stem}"
        try:
            create_table_from_csv(str(csv_path), table_name)
            rows = load_data_to_csv(str(csv_path), table_name)
            logger.info("%s -> %d rows", csv_path.name, rows)
        except Exception:
            logger.exception("Failed on %s", csv_path.name)


if __name__ == "__main__":
    main()
