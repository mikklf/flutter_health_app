from flask import Flask, request
from preprocessing import preprocess_csv
import datetime
import pandas as pd
from io import StringIO
import os

app = Flask(__name__)

@app.route("/", methods=['POST', 'GET'])
def index():
    if request.method == 'GET':
        return "Send a POST request with csv data in body to this endpoint", 405

    print("Received data from client")

    data = request.data.decode()

    update_database("raw_data.csv", data)

    preprocess("raw_data.csv")

    return "OK", 200



def update_database(file_path, data):
    ''' Updates the database with the new data, keeping only the last entry for each date '''

    data = pd.read_csv(StringIO(data))

    # If the database does not exist, the new data is the database
    if not os.path.exists(file_path):
        data.to_csv(file_path, index=False)
        return

    # Otherwise, read the database and append the new data
    db = pd.read_csv(file_path)
    updated_db = pd.concat([db, data])

    # Do not keep entries with dates that already exist in the database
    updated_db.drop_duplicates(subset=['Date'], keep='last', inplace=True)

    updated_db.to_csv(file_path, index=False)

def preprocess(file_path):
    ''' Preprocess the csv file and saves it to preprocessed_data.csv'''

    try:
        preprocessd_data = preprocess_csv(file_path)
    except Exception as e:
        print(f"Error preprocessing data: {e}")
        return str(e), 400

    print("Preprocessed data:")
    print(preprocessd_data)

    # Save the preprocessed data to a file
    preprocessd_data.to_csv("preprocessed_data.csv", index=False)
    print(f"Saved preprocessed data to preprocessed_data.csv")


if __name__ == '__main__':
    app.run()