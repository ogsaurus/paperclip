---
description: Deploy a fresh local build of Paperclip using Docker Compose.
---

When instructed to deploy Paperclip to the local Docker architecture, follow these steps exactly.

1. Navigate to the repo root where the `Dockerfile` and `docker-compose.yml` reside.
2. Build the local Docker image using the `local` tag:
```bash
docker build -t paperclip:local .
```
3. Once the build completes successfully, restart the Paperclip container stack (replace `paperclip` with the exact compose service name if different):
```bash
docker compose up -d
```
4. Verify the container is running and healthy:
```bash
docker compose ps
```
5. If the logs are requested or a smoke test is needed, run:
```bash
docker compose logs --tail=100
```

### Advanced Config
If the environment requires sandbox disabling inside Docker, make sure `PAPERCLIP_GEMINI_DISABLE_SANDBOX=1` is injected into the `.env` or `docker-compose.yml` environment block prior to bringing the containers up.
