# 🛒 Ecommerce Sales Dashboard

An end-to-end data analytics project: raw ecommerce sales data → cleaning in Python → analysis in SQL → interactive Power BI dashboard.

## Objective
Track sales performance and answer business questions:
- Which categories and products drive revenue and profit?
- Which regions perform best?
- How do sales change month to month and year over year?
- Does discounting hurt profit?

## Tools & Technologies
Python (Pandas) · SQL (MySQL ) · Power BI (DAX) · Excel

## Project Structure
```
ecommerce-sales-dashboard/
├── data/
│   ├── raw_sales_data.csv          # 4,716 raw rows (duplicates, blanks, extra spaces)
│   └── cleaned_sales_data.csv      # 4,643 cleaned rows
├── scripts/
│   ├── generate_dataset.py         # creates the sample dataset
│   └── data_cleaning.py            # cleans the raw data
├── sql/
│   └── sales_analysis.sql          # table creation + 9 analysis queries
├── dashboard/
│   ├── dax_measures.txt            # DAX measures + visual layout
│   └── screenshots/                # add dashboard screenshots here
└── README.md
```

## Workflow
1. **Data cleaning** (`scripts/data_cleaning.py`): standardized column names, removed 58 duplicate rows, dropped 15 rows with missing sales, filled 25 missing regions as "Unknown", trimmed text, fixed date types, and added year, month and profit margin columns.
2. **SQL analysis** (`sql/sales_analysis.sql`): KPIs, monthly trends, category / product / region / customer analysis, YoY growth (window functions) and discount impact.
3. **Dashboard** (`dashboard/dax_measures.txt`): Power BI report with KPI cards, trend lines, category and region charts, and slicers for year, category and region.

## Key KPIs (2022–2024)
| Metric | Value |
|---|---|
| Total Sales | 5.34 crore (53.39M) |
| Total Profit | 61.5 lakh (6.15M) |
| Profit Margin | 11.53% |
| Total Orders | 2,595 |
| Average Order Value | 20,573 |
| Customers | 420 |

## Key Insights
- **Technology** drives 64.6% of revenue but has the lowest margin (7.7%); **Books & Stationery** and **Fashion** have the highest margins (33.5% and 31.0%).
- **Laptops** are the most profitable sub-category (about 15.2 lakh profit); **Laptop Pro 14** is the top product by revenue.
- Sales grew **13.1% in 2023** and **34.2% in 2024** year over year.
- **October** is the peak sales month, with strong sales through the festive season (Oct–Dec).
- **South** is the largest region (29.1% of sales); **North** and **West** each contribute about 24%.
- **Discounts above 20% turn profit negative** (about -5.4 lakh), while orders with no discount earn the most profit.

## How to Run
```bash
pip install pandas
python scripts/generate_dataset.py   # optional: the data is already included
python scripts/data_cleaning.py
```
Then run `sql/sales_analysis.sql` in MySQL or PostgreSQL, and build the dashboard in Power BI using `data/cleaned_sales_data.csv` and `dashboard/dax_measures.txt`.

## Author
Battala Lalitha
