from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/healthz')
def healthz():
    sys_env = os.getenv('SYS_ENV', 'default')
    return jsonify({'status': 'healthy', 'sys_env': sys_env}), 200

@app.route('/metrics')
def metrics():
    # Simple counter metric for demo
    return 'app_requests_total 42\n', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

