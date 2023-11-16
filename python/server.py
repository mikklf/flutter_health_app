from flask import Flask, request
from preprocessing import preprocess
import datetime

app = Flask(__name__)

@app.route("/", methods=['POST', 'GET'])
def index():
    if request.method == 'GET':
        return "Send a POST request with csv data in body to this endpoint", 405

    print("Received data from client")

    # Get the data from the request
    data = request.data.decode()

    # Preprocess the data
    try:
        preprocessd_data = preprocess(data)
    except Exception as e:
        print(f"Error preprocessing data: {e}")
        return str(e), 400

    print("Preprocessed data")
    print(preprocessd_data)

    # Save the preprocessed data to a file
    now = datetime.datetime.now()
    file_name = f"preprocessed_data_{now.strftime('%Y-%m-%d_%H-%M-%S')}.csv"
    preprocessd_data.to_csv(file_name, index=False)
    print(f"Saved preprocessed data to {file_name}")

    # return 200 OK
    return "OK", 200

if __name__ == '__main__':
    app.run()