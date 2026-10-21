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
