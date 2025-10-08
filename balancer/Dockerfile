FROM nginx:1.27-alpine
RUN apk add --no-cache ca-certificates
COPY nginx.conf /etc/nginx/nginx.conf
# Certs will be mounted at runtime to /etc/nginx/certs (read-only)