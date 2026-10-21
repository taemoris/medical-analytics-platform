import os
from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class ClickhouseConfig:
    host: str = os.getenv("CLICKHOUSE_HOST")
    port: int = os.getenv("CLICKHOUSE_PORT")
    user: str = os.getenv("CLICKHOUSE_USER")
    password: str = os.getenv("CLICKHOUSE_PASSWORD")
    database: str = os.getenv("CLICKHOUSE_DB")

    def validate(self):
        if not self.password:
            raise ValueError("CLICKHOUSE_PASSWORD is not set")
        if not self.user:
            raise ValueError("CLICKHOUSE_USER is not set")


ch_config = ClickhouseConfig()
