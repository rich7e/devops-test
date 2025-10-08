FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates netcat-openbsd && rm -rf /var/lib/apt/lists/*
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir gunicorn==22.0.0
COPY app.py ./
EXPOSE 8443
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD nc -z localhost 8443 || exit 1
# Run with TLS
CMD ["gunicorn","--workers","2","--bind","0.0.0.0:8443",      "--certfile","/etc/app-tls/server.crt","--keyfile","/etc/app-tls/server.key",      "--ca-certs","/etc/app-tls/ca.crt","--cert-reqs","2",      "app:app"]