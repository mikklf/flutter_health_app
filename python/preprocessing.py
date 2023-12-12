import pandas as pd
from sklearn.impute import SimpleImputer
from io import StringIO


def preprocess_csv(file_path):
    """
    Preprocess the csv file and return a dataframe
    """

    # Read the data into a dataframe
    data = pd.read_csv(file_path)

    # Drop the columns that only contain NaN values
    data.dropna(axis=1, how='all', inplace=True)

    # Convert 'Date' to datetime for manipulation
    data['Date'] = pd.to_datetime(data['Date'])

    # Sort the data by date to ensure proper backfilling
    data.sort_values(by='Date', inplace=True)

    # Drop the 'Date' column
    data.drop(columns=['Date'], inplace=True)

    # Backfill kellner scores for up to 7 days backwards, since they are answered weekly
    for col in ['DepressionScaleScore', 'DepressionSubscaleScore', 'ContentmentSubscaleScore']:
        data[col] = data[col].bfill(limit=7)

    # For the remaining missing values, fill them with -1 to indicate missing values
    data['DepressionScaleScore'].fillna(-1, inplace=True)
    data['DepressionSubscaleScore'].fillna(-1, inplace=True)
    data['ContentmentSubscaleScore'].fillna(-1, inplace=True)

    # For 'Weight', we will forward-fill the missing values first and then backward-fill the remaining
    data['Weight'] = data['Weight'].ffill()
    data['Weight'] = data['Weight'].bfill()

    numerical_cols = ['Steps', 'AverageHeartRate', 'MinHeartRate', 'MaxHeartRate', 
                    'HomestayPercent', 'AverageTemperature', 'CloudinessPercent', 
                    'DaylightTimeInHours']

    # Update the list to include only those columns that are present in the dataframe
    numerical_cols = [col for col in numerical_cols if col in data.columns]

    # For the weather conditions, we will use the nearest known value to fill the missing values
    data['IsRaining'] = data['IsRaining'].interpolate(method='nearest')
    data['IsSnowing'] = data['IsSnowing'].interpolate(method='nearest')

    # Imputing missing values
    # For numerical columns, we'll use the median (to avoid the influence of outliers)
    num_imputer = SimpleImputer(strategy='median')
    data[numerical_cols] = num_imputer.fit_transform(data[numerical_cols])

    # Scaling is not needed for decision trees
    return data