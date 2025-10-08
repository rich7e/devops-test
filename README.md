
# DevOps Test — Section 3 (Full Implementation)

Полная реализация раздела **3. Детализация требований** с рабочими примерами:
- Docker/Compose, разделение сетей
- Балансировка и отказоустойчивость (Nginx, health-checks)
- TLS и mTLS (демо через самоподписанные сертификаты)
- Мониторинг и логирование (Prometheus, экспортеры)
- CI/CD (GitHub Actions, Jenkinsfile) c blue/green (канареечное) переключение
- IaC (Terraform docker provider, модули)
- Диагностика/трассировка (описание и заготовки)

## Быстрый старт (локально)

```bash
# 0) (Опционально) Сгенерировать самоподписанные сертификаты и загрузить в volumes
./scripts/generate-certs.sh

# 1) Поднять окружение
docker compose -f compose/docker-compose.yml up -d --build

# 2) Проверки
curl -f http://localhost/health
curl -f http://localhost/ | jq .
curl -f http://localhost/metrics

# 3) Prometheus
open http://localhost:9090
```
