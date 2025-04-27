from collect_data import get_timeframes, work_with_GoogleTrends
from decompose import decomposition, running_average
from google.auth import default
from upload_to_bigquery import upload_to_bigquery
import pandas as pd

def process_df(df, cycle, bucket):
    # Keep only 'date' and 'values' columns and remove duplicates
    df = df[['date', 'values']].drop_duplicates()
    df.set_index('date', inplace=True)

    # Decompose the time series into trend, seasonality, residuals
    values, trend, seasonality, residuals = decomposition(df, cycle)
    detrended = df.iloc[cycle:].values.flatten() / trend
    trendShifted = pd.Series(trend).shift(int(cycle * -0.5 + 1)).values

    # Align all series to the minimal common length
    min_len = min(
        len(df.index[cycle:]),
        len(values[cycle:]),
        len(trend),
        len(trendShifted),
        len(seasonality),
        len(residuals),
        len(detrended)
    )

    # Create a unified DataFrame with aligned lengths
    date_series = pd.Series(df.index[cycle:][:min_len])
    df_final = pd.DataFrame({
        'date': date_series.values,
        'values': values[cycle:][:min_len],
        'trend': trend[:min_len],
        'trendShifted': trendShifted[:min_len],
        'seasonality': seasonality[:min_len],
        'residuals': residuals[:min_len],
        'detrended': detrended[:min_len],
        'bucket': [bucket] * min_len,
        'bucketNo': (
            date_series.dt.month
            if bucket == 'monthly'
            else date_series.dt.isocalendar().week
        )
    })

    return df_final.fillna(0)

def main():
    tf = get_timeframes()
    result = pd.DataFrame()

    # Process data for each timeframe: daily, weekly, monthly
    for bucket, cycle in zip(['daily', 'weekly', 'monthly'], [7, 4, 12]):
        df = work_with_GoogleTrends(tf[bucket])
        if df is not None:
            result = pd.concat([result, process_df(df, cycle, bucket)])

    # Convert final result to records and upload to BigQuery
    records = result.to_dict('records')
    upload_to_bigquery(records, "dbexchange.dbo.tbGT_CreditOnline_test")

if __name__ == "__main__":
    main()
