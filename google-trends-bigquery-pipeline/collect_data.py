from pytrends.request import TrendReq
from datetime import date, timedelta
from calendar import monthrange
from dateutil.relativedelta import relativedelta
import time, random
import pandas as pd

def fetch_data_with_retries(pytrends, max_retries=5, min_wait=60, max_wait=180):
    """Fetch Google Trends data with automatic retries on rate limit errors (HTTP 429)."""
    for attempt in range(1, max_retries + 1):
        try:
            return pytrends.interest_over_time()
        except Exception as e:
            if "429" in str(e):
                wait_time = random.randint(min_wait, max_wait)
                print(f"[Attempt {attempt}/{max_retries}] Rate limited. Waiting {wait_time} seconds before retrying...")
                time.sleep(wait_time)
            else:
                raise e
    print("❌ All attempts to fetch data failed.")
    return None

def work_with_GoogleTrends(timeframe, keyword="кредит онлайн", geo="UA"):
    """Query Google Trends for a given keyword and timeframe. Customize 'keyword' and 'geo' if needed."""
    pytrends = TrendReq()
    pytrends.build_payload([keyword], geo=geo, timeframe=timeframe)
    df = fetch_data_with_retries(pytrends)
    if df is not None:
        df.reset_index(inplace=True)
        df.rename(columns={keyword: 'values'}, inplace=True)  # Rename the keyword column to 'values' for consistency
    return df

def get_timeframes():
    """Generate daily, weekly, and monthly timeframes based on today's date."""
    days_in_month = lambda dt: monthrange(dt.year, dt.month)[1]
    today = date.today()
    next_month = today.replace(day=1) + timedelta(days_in_month(today))

    monthly_start = next_month + relativedelta(years=-7)
    weekly_start = next_month + relativedelta(years=-5)
    daily_start = next_month + relativedelta(months=-4)

    return {
        "daily": f"{daily_start} {next_month}",
        "weekly": f"{weekly_start} {next_month + relativedelta(years=1)}",
        "monthly": f"{monthly_start} {next_month + relativedelta(years=1)}"
    }
