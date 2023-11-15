import pandas as pd
from sklearn.impute import SimpleImputer

# Read the data from file using read_csv
data = pd.read_csv('python\data2.txt')

# Drop the columns that only contain NaN values
data.dropna(axis=1, how='all', inplace=True)

# Convert 'Date' to datetime for manipulation
data['Date'] = pd.to_datetime(data['Date'])

# Sort the data by date to ensure proper backfilling
data.sort_values(by='Date', inplace=True)

# Drop the 'Date' column
data.drop(columns=['Date'], inplace=True)

# Backfill the specific columns up to 7 days
for col in ['DepressionScaleScore', 'DepressionSubscaleScore', 'ContentmentSubscaleScore']:
    data[col] = data[col].bfill(limit=7)

# Drop rows where these columns are still NaN (indicating no record within 7 days)
data.dropna(subset=['DepressionScaleScore', 'DepressionSubscaleScore', 'ContentmentSubscaleScore'], inplace=True)

# For 'Weight', we will forward-fill the missing values first and then backward-fill the remaining
data['Weight'] = data['Weight'].ffill()
data['Weight'] = data['Weight'].bfill()

numerical_cols = ['Steps', 'AverageHeartRate', 'MinHeartRate', 'MaxHeartRate', 
                  'HomestayPercent', 'AverageTemperature', 'CloudinessPercent', 
                  'DaylightTimeInHours']
# Update the list to include only those columns that are present in the dataframe
numerical_cols = [col for col in numerical_cols if col in data.columns]
categorical_cols = ['isRainyOrSnowy']
# Update the list to include only those columns that are present in the dataframe
categorical_cols = [col for col in categorical_cols if col in data.columns]

# Imputing missing values
# For numerical columns, we'll use the median (to avoid the influence of outliers)
# For categorical columns, we'll use the mode (most frequent value)
num_imputer = SimpleImputer(strategy='median')
cat_imputer = SimpleImputer(strategy='most_frequent')

# Apply the imputers
data[numerical_cols] = num_imputer.fit_transform(data[numerical_cols])
data[categorical_cols] = cat_imputer.fit_transform(data[categorical_cols])

# Scaling is not needed for decision trees

print(data.head(n = 30))

print(data.isnull().sum())