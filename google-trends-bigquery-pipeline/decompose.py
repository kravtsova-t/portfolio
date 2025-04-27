import numpy as np

def running_average(x, order):
    """Calculate running (moving) average over a specified window size (order)."""
    current = x[:order].sum()
    running = []
    for i in range(order, x.shape[0]):
        current += x[i]            # Add the new element
        current -= x[i - order]     # Remove the element that is out of the window
        running.append(current / order)  # Calculate average
    return np.array(running)

def decomposition(data, order):
    """
    Decompose time series into components: trend, seasonality, and residuals.

    Args:
        data (pandas DataFrame or Series): Time series data with a single value column.
        order (int): Period of seasonality (e.g., 7 for weekly, 12 for monthly).

    Returns:
        tuple: (original values, trend, seasonality, residuals)
    """
    values = data.values.flatten()  # Flatten the data to a 1D array
    trend = running_average(values, order)  # Calculate trend using running average
    detrended = values[order:] / trend  # Remove trend from the original data
    season = [detrended[i::order].mean() for i in range(order)]  # Estimate seasonal pattern
    seasonality = np.array(season * (len(detrended) // order + 1))[:len(detrended)]  # Repeat seasonality pattern
    residuals = values[order:] / (trend * seasonality)  # Calculate residuals after removing trend and seasonality
    return values, trend, seasonality, residuals
