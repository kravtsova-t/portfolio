# 📈 Google Trends Time Series Analysis (Python + GCP)

This project is a Python script wrapped into a function and optimized for deployment on **Google Cloud Platform (GCP)** using **Cloud Run Function**.

It collects and analyzes search interest data from **Google Trends** using the open-source [`pytrends`](https://github.com/GeneralMills/pytrends) library, decomposes time series into meaningful components, and uploads structured results to **Google BigQuery** for further analysis or visualization.

✨ This project demonstrates how to automate public trend analysis and make it production-ready with GCP tools.

---

## 🔗 Data Flow Architecture

```text
Cloud Run Function (Python)
        ↓
   [Pytrends] → Google Trends API
        ↓
Decomposition (Trend / Seasonality / Residuals)
        ↓
     Google BigQuery (structured table)
```

---

## 🚀 Features

- 📅 Fetches **daily, weekly, monthly** search data (e.g., `"кредит онлайн"`)
- 📊 Decomposes time series into:
  - Trend
  - Seasonality
  - Residuals
- 🗃️ Uploads cleaned & structured data to **BigQuery**
- 📦 Built with `pytrends`, `pandas`, `numpy`, `matplotlib`
- ☁️ Ready for **Cloud Run Function** deployment

---

## 📦 Dependencies

Make sure to install the required packages:

```bash
pip install -r requirements.txt
```

---

## 📁 Project Structure

```text
google-trends-bigquery-pipeline/
├── main.py                     # Entry point for data collection & processing
├── collect_data.py             # Fetching Google Trends data
├── decompose.py                # Time series decomposition logic
├── upload_to_bigquery.py       # BigQuery interaction
├── requirements.txt
└── README.md
```

---

## 📚 References

- [pytrends library (Unofficial Google Trends API) on GitHub](https://github.com/GeneralMills/pytrends)
- [pytrends on PyPI](https://pypi.org/project/pytrends/)
- [Deploy functions in Cloud Run](https://cloud.google.com/run/docs/deploy-functions)

---

