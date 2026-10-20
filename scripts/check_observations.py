from pathlib import Path

import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = PROJECT_ROOT / "data" / "raw" / "synthea" / "observations.csv"

KEY_COLUMNS = ["DATE", "PATIENT", "ENCOUNTER", "CODE"]


def main() -> None:
    df = pd.read_csv(DATA_PATH, delimiter=",", encoding="utf-8")

    duplicate_mask = df.duplicated(subset=KEY_COLUMNS, keep=False)
    duplicate_rows = int(duplicate_mask.sum())
    unique_keys = df[KEY_COLUMNS].drop_duplicates().shape[0]

    print(f"File: {DATA_PATH.name}")
    print(f"Rows: {len(df)}")
    print(f"Columns: {df.shape[1]}")
    print(f"Rows in repeated-key groups: {duplicate_rows}")
    print(f"Unique key combinations: {unique_keys}")

    print("Number of empty values in columns:")
    print(df.isna().sum())

    empty_rows_in_encounter_and_category = len(df[(df["ENCOUNTER"].isna()) & (df["CATEGORY"].isna())])
    print(empty_rows_in_encounter_and_category)


if __name__ == "__main__":
    main()
