from google.cloud import bigquery
import pandas as pd
import datetime

def upload_to_bigquery(records, table_id):
    """
    Upload a list of records to a BigQuery table after cleaning and formatting the data.

    Args:
        records (list of dicts): Data to upload.
        table_id (str): Full table ID in the format `project.dataset.table`.
    """
    # Define allowed fields that should remain in the record
    allowed_fields = {
        'date', 'values', 'trend', 'trendShifted',
        'seasonality', 'residuals', 'detrended', 'bucket', 'bucketNo'
    }

    for row in records:
        for key in list(row.keys()):
            value = row[key]
            # Remove any keys not in the allowed fields
            if key not in allowed_fields:
                del row[key]
                continue
            # Format date fields as ISO format (YYYY-MM-DD)
            if isinstance(value, (pd.Timestamp, datetime.datetime, datetime.date)):
                row[key] = value.isoformat()[:10]
            # Ensure numeric fields are floats rounded to 9 decimal places
            elif key in ['values', 'trend', 'trendShifted', 'seasonality', 'residuals', 'detrended']:
                try:
                    row[key] = round(float(value), 9)
                except:
                    row[key] = 0.0
            # Ensure bucketNo is an integer
            elif key == 'bucketNo':
                try:
                    row[key] = int(value)
                except:
                    row[key] = 0
            # Ensure bucket is a string
            elif key == 'bucket':
                row[key] = str(value)

    # Initialize BigQuery client
    client = bigquery.Client()

    # Clear the table before uploading new data
    client.query(f"TRUNCATE TABLE {table_id}").result()

    # Insert cleaned records into BigQuery
    errors = client.insert_rows_json(table_id, records)

    # Handle and print the result
    if not errors:
        print("✅ Data successfully uploaded to BigQuery.")
    else:
        print("❌ Errors during upload:")
        for error in errors:
            print(error)
