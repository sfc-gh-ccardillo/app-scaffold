import os
import snowflake.connector
from flask import Flask, jsonify, make_response


def get_login_token():
  with open('/snowflake/session/token', 'r') as f:
    return f.read()

conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth'
)

app = Flask(__name__)

@app.route("/")
def default():
    return make_response(jsonify(result='Hello from backend'))

@app.route("/user-info")
def user_info():
    res = conn.cursor().execute("SELECT CURRENT_USER()").fetchone()
    return make_response(jsonify(result=str(res)))

if __name__ == '__main__':
    app.run(port=8081, host='0.0.0.0')
