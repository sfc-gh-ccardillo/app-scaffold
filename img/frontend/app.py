import requests
from flask import Flask, jsonify, make_response

app = Flask(__name__)

@app.route("/")
def default():
    return make_response(jsonify(result='Hello from frontend'))

@app.route("/hello")
def hello():
    return requests.get("http://localhost:8000/backend").json()

@app.route("/query")
def query():
    return requests.get("http://localhost:8000/backend/user-info").json()

if __name__ == '__main__':
    app.run(port=8080, host='0.0.0.0')
