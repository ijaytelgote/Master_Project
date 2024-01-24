from flask import Flask, jsonify
from flask_cors import CORS  # Import the CORS module
import pandas as pd
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Assume you have processed data in the output_df variable
# Replace this with your actual processed data
data = {'X': [1, 2, 3, 4, 5],
        'Y': [2, 4, 1, 3, 5]}
output_df = pd.DataFrame(data)

@app.route('/api/scatter_data', methods=['GET'])
def get_scatter_data():
    try:
        return jsonify(output_df.to_dict(orient='records')), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
