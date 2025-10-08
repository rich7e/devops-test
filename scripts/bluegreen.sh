#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:?Usage: bluegreen.sh <image-ref>}"

echo "==> Using image: $IMAGE_REF"

docker compose up -d db balancer || true

echo "==> Starting GREEN replicas..."
docker rm -f app_green1 app_green2 >/dev/null 2>&1 || true
docker run -d --name app_green1 --network devops-test_app-net "$IMAGE_REF"
docker run -d --name app_green2 --network devops-test_app-net "$IMAGE_REF"

echo "==> Updating Nginx upstream for partial traffic..."
docker exec balancer sh -c "
if ! grep -q app_green1 /etc/nginx/nginx.conf; then
  sed -i '/upstream app_backend {/a\    server app_green1:8443 weight=10;\n    server app_green2:8443 weight=10;' /etc/nginx/nginx.conf
fi
nginx -s reload
"

echo "==> Health checking GREEN for 30s..."
sleep 30
GREEN_ERRS=$( (docker logs app_green1 2>&1; docker logs app_green2 2>&1) | grep -Ei 'error|traceback|exception' | wc -l || true)

if [ "$GREEN_ERRS" -gt 0 ]; then
  echo "==> Errors detected in GREEN, rolling back"
  docker exec balancer sh -c "
    sed -i '/app_green/d' /etc/nginx/nginx.conf
    nginx -s reload
  "
  docker rm -f app_green1 app_green2 || true
  exit 1
fi

echo "==> GREEN healthy, promoting to 100%"
docker exec balancer sh -c "
  sed -i 's/server app1:8443 weight=[0-9]\+/server app1:8443 weight=0/;
          s/server app2:8443 weight=[0-9]\+/server app2:8443 weight=0/;
          s/server app_green1:8443 weight=[0-9]\+/server app_green1:8443 weight=100/;
          s/server app_green2:8443 weight=[0-9]\+/server app_green2:8443 weight=100/' /etc/nginx/nginx.conf
  nginx -s reload
"

docker compose stop app1 app2 || true

echo "==> Deployment complete."
