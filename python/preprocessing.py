import pandas as pd
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler

# Read the data from file using read_csv
data = pd.read_csv('C:\\Users\\mikke\\Desktop\\data.csv')

print(data.head())

# Create an imputer object with a median filling strategy for heart rates
imputer_heart_rate = SimpleImputer(strategy='median')

# Apply the imputer to our data
data[['AverageHeartRate', 'MinHeartRate', 'MaxHeartRate']] = imputer_heart_rate.fit_transform(
    data[['AverageHeartRate', 'MinHeartRate', 'MaxHeartRate']])

# For 'Weight', we will forward-fill the missing values
data['Weight'] = data['Weight'].fillna(method='ffill')

# Create a StandardScaler object
scaler = StandardScaler()

data['HumidityPercent'] = data['HumidityPercent'] / 100
data['CloudinessPercent'] = data['CloudinessPercent'] / 100
data['HomestayPercent'] = data['HomestayPercent'] / 100

# List of numerical columns to scale (excluding 'Date' which is not a feature and 'WeatherCondition' which is categorical)
numerical_columns = ['AverageHeartRate', 'MinHeartRate', 'MaxHeartRate', 'Steps', 
                     'AverageTemperature', 'MinTemperature', 'MaxTemperature', 'DaylightTimeInHours', 'Weight']


data[numerical_columns] = scaler.fit_transform(data[numerical_columns])

print(data.head())