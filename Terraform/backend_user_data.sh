#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip
pip3 install flask flask_cors

cat <<EOF > /home/ubuntu/app.py
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/submit', methods=['POST'])
def submit():
    return jsonify({"message": "Data received!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

nohup python3 /home/ubuntu/app.py > /home/ubuntu/flask.log 2>&1 &
