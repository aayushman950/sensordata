from flask import Flask, jsonify
from influxdb_client import InfluxDBClient, QueryApi

# Flask app
app = Flask(__name__)

# InfluxDB connection details
bucket = "SensorData"
org = "AQMS"
token = "cnuD2krG9s06LeYhs2zty7ZDf08zjP_1LrpPymhtWL9Rn6FwTPyiO2iPr0fkwbYf16LaEI-E25CJLSGr6PcNeg==" 
url = "http://localhost:8086" 

# Initialize InfluxDB client
client = InfluxDBClient(url=url, token=token, org=org)
query_api = client.query_api()

# Endpoint to fetch the latest data
@app.route('/latest', methods=['GET'])
def get_latest_data():
    """
    Endpoint to fetch the latest data
    """
    query = f'from(bucket: "{bucket}") |> range(start: -1h) |> sort(columns: ["_time"], desc: true) |> limit(n: 1)'
    try:
        tables = query_api.query(query=query, org=org)
        results = []

        for table in tables:
            for record in table.records:
                results.append({
                    "time": record.get_time(),
                    "field": record.get_field(),
                    "value": record.get_value(),
                    "location": record.values.get("location", "Unknown")
                })

        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Endpoint to fetch historical data
@app.route('/history', methods=['GET'])
def get_historical_data():
    """
    Endpoint to fetch historical data
    """
    # query = f'from(bucket: "{bucket}") |> range(start: -7d) |> sort(columns: ["_time"], desc: false) |> limit(n: 100)'

    query = f'''
from(bucket: "{bucket}")
  |> range(start: -7d)
  |> filter(fn: (r) => r["_field"] == "AQI" or r["_field"] == "PM2.5" or r["_field"] == "PM10") 
  |> aggregateWindow(every: 1d, fn: mean, createEmpty: false)
  |> sort(columns: ["_time"], desc: false)
'''

    try:
        tables = query_api.query(query=query, org=org)
        results = []

        for table in tables:
            for record in table.records:
                # Check fields to only include AQI, PM2.5, and PM10
                if record.get_field() in ["AQI", "PM2.5", "PM10"]:
                    results.append({
                        "time": record.get_time(),
                        "field": record.get_field(),
                        "value": record.get_value()
                    })

        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True, port=5000)
