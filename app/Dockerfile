
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential ca-certificates netcat-openbsd && rm -rf /var/lib/apt/lists/*
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py ./
EXPOSE 5000
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD nc -z localhost 5000 || exit 1
CMD ["python","app.py"]
