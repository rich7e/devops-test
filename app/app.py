
import os, socket, time, json
import psycopg2
from flask import Flask, jsonify, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQ_COUNT = Counter("http_requests_total", "HTTP requests", ["method","path","status"])
REQ_LAT = Histogram("http_request_duration_seconds", "HTTP request duration seconds", ["path"])

def get_db_version():
    import time
    for attempt in range(10):
        try:
            conn = psycopg2.connect(
                dbname=os.getenv("POSTGRES_DB", "appdb"),
                user=os.getenv("POSTGRES_USER", "appuser"),
                password=os.getenv("POSTGRES_PASSWORD", "apppass"),
                host=os.getenv("POSTGRES_HOST", "db"),
                port=int(os.getenv("POSTGRES_PORT", "5432")),
                connect_timeout=3
            )
            cur = conn.cursor()
            cur.execute("SELECT version();")
            v = cur.fetchone()[0]
            cur.close()
            conn.close()
            return v
        except Exception as e:
            app.logger.warning(json.dumps({
                "event": "db_retry",
                "attempt": attempt + 1,
                "error": str(e)
            }))
            time.sleep(2)
    app.logger.error(json.dumps({
        "event": "db_error",
        "error": "Failed to connect to DB after 10 attempts"
    }))
    return None

@app.route("/")
def root():
    start = time.time()
    dbv = get_db_version()
    status = 200 if dbv else 500
    payload = {"hostname": socket.gethostname(), "db_version": dbv, "status": status}
    REQ_LAT.labels("/").observe(time.time()-start)
    REQ_COUNT.labels("GET","/",status).inc()
    return jsonify(payload), status

@app.route("/health")
def health():
    return "ok\n", 200

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
