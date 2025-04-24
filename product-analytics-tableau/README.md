# 📦 Product Analytics Portfolio — Tableau Dashboards

This repository contains two Tableau dashboards showcasing product analytics skills:

---

## 🔹 1. Retention & Funnel Analysis

**File:** `retention_dashboard.twbx`

**Description:**  
Analyzes user retention and login behavior by cohort for users registered in 2018.  
Includes a funnel, retention matrix, and engagement trend breakdown.

**Key Features:**
- User login funnel (Day 1 → Day 3 → Day 5 → Day 7)
- Retention matrix by registration month
- Cohort-based login visualization
- Calculated conversion rates between steps

---

## 🔹 2. A/B Test Monetization Report

**File:** `ab_test_dashboard.twbx`

**Description:**  
Compares two user groups (A and B) based on monetization metrics for users who registered in 2018.  
Includes KPI tiles and statistical test results.

**Key Metrics:**
- ARPU (Average Revenue Per User)
- ARPPU (Average Revenue Per Paying User)
- % of Paying Users
- Uplift between groups
- T-test and Z-test p-values (external analysis)

---

## 📁 Folder Structure

<pre> 📁 product-analytics-tableau/
├── 📄 README.md                      
├── 📁 dashboards/                    
│   ├── retention_dashboard.twbx
│   └── ab_test_dashboard.twbx   
├── 📁 data/       
│   ├── funnel.csv
│   ├── kpi.csv
│   ├── retention_matrix.csv
│   ├── ab_test.csv
│   └── ab_test_cohort.csv
├── 📁 screenshots/                  
│   ├── retention_preview.png
│   └── ab_test_preview.png </pre>
├── 📁 sql/ 
│   ├── funnel.sql
│   ├── kpi.sql
│   ├── retention_matrix.sql
│   ├── ab_test.sql
│   └── ab_test_cohort.sql

---

## 📥 How to View

- Download any `.twbx` file from the `dashboards/` folder.
- Open it in [Tableau Public](https://public.tableau.com/en-us/s/download) or Tableau Desktop.
- No setup required — data is included.

---

## 🛠 Tech Stack

- **PostgreSQL** — data modeling, cohort segmentation, A/B test logic
- **Tableau Desktop / Public** — dashboard design and KPI visualization
- **Kaggle datasets** — [Gamelytics Mobile Analytics Challenge](https://www.kaggle.com/datasets/debs2x/gamelytics-mobile-analytics-challenge/data)

---

## 🔄 Data Preparation (ETL)

Before building dashboards in Tableau, the raw CSV files from Kaggle were processed through a basic ETL pipeline using **PostgreSQL**:

- Loaded `.csv` files into PostgreSQL using `COPY` commands
- Converted **Unix timestamps** (e.g., `reg_ts`, `auth_ts`) into readable `TIMESTAMP` format
- Built **SQL logic for funnel steps**, **retention by cohorts**, and **A/B test groups**
- Aggregated cohort metrics by **registration month**, **login month**, and **revenue**
- Used **SQL joins**, **filters**, and **calculated fields** for shaping the data

> ✅ This preprocessing ensured clean, structured data before visualizing it in Tableau.

---

## 📦 Dataset

This project uses public data from the [Gamelytics Mobile Analytics Challenge on Kaggle](https://www.kaggle.com/datasets/debs2x/gamelytics-mobile-analytics-challenge/data), which simulates mobile app user behavior including registrations, logins, and monetization data.

