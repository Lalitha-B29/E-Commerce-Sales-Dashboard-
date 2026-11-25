"""
Data cleaning for the Ecommerce Sales Dashboard.
Run from anywhere:  python scripts/data_cleaning.py
Input : data/raw_sales_data.csv
Output: data/cleaned_sales_data.csv
"""
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
RAW_PATH = ROOT / "data" / "raw_sales_data.csv"
CLEAN_PATH = ROOT / "data" / "cleaned_sales_data.csv"

# 1. Load data
df = pd.read_csv(RAW_PATH, encoding="utf-8")
print("Raw shape:", df.shape)

# 2. Standardize column names
df.columns = (
    df.columns.str.strip().str.lower().str.replace(" ", "_").str.replace("-", "_")
)

# 3. Remove duplicates
before = len(df)
df = df.drop_duplicates()
print("Duplicates removed:", before - len(df))

# 4. Fix data types
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")

# 5. Handle missing values
missing = df.isna().sum()
print("Missing values before cleaning:\n", missing[missing > 0])
df = df.dropna(subset=["order_id", "order_date", "sales"])
text_cols = [c for c in df.columns if c not in ("order_date", "sales", "quantity", "discount", "profit")]
df[text_cols] = df[text_cols].fillna("Unknown")

# 6. Clean text columns
for col in text_cols:
    df[col] = df[col].str.strip()

# 7. Create new columns for analysis
df["year"] = df["order_date"].dt.year
df["month"] = df["order_date"].dt.month_name()
df["month_num"] = df["order_date"].dt.month
df["profit_margin_pct"] = (df["profit"] / df["sales"] * 100).round(2)

# 8. Save cleaned data
df.to_csv(CLEAN_PATH, index=False)
print("Cleaned shape:", df.shape)
print(f"Saved to {CLEAN_PATH}")
