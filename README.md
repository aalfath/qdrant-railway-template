[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/qdrant-3?utm_medium=integration&utm_source=button&utm_campaign=qdrant)

# Qdrant on Railway

One-click [Qdrant](https://qdrant.tech) vector database for Railway, built from the official image `qdrant/qdrant:v1.20.1` (pinned by digest in the [`Dockerfile`](Dockerfile)).

## What it deploys

One service, **Qdrant**, built from this repo:

- HTTP/REST API and the Web UI (`/dashboard`) on the service's public Railway domain (port `6333`).
- gRPC API on port `6334`, reachable from your other Railway services over the private network: `${{Qdrant.RAILWAY_PRIVATE_DOMAIN}}:6334`.
- A volume at `/qdrant/data` holding collections (`/qdrant/data/storage`) and snapshots (`/qdrant/data/snapshots`).
- An API key, generated at deploy time. Every request except the health endpoints needs it in the `api-key` header (or as `Authorization: Bearer <key>`). The container refuses to start without a key.
- Health check on `/readyz`.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `QDRANT__SERVICE__API_KEY` | `${{secret(48)}}` | API key for the REST API, gRPC and the Web UI |
| `PORT` | `6333` | HTTP port; the public domain and the health check point here |

Any other [Qdrant setting](https://qdrant.tech/documentation/guides/configuration/) can be added as a `QDRANT__SECTION__KEY` variable, for example `QDRANT__SERVICE__READ_ONLY_API_KEY` for a read-only key, or `QDRANT__TELEMETRY_DISABLED=true` to turn off Qdrant's anonymous telemetry.

## Connect from another Railway service

```
QDRANT_URL=http://${{Qdrant.RAILWAY_PRIVATE_DOMAIN}}:6333
QDRANT_API_KEY=${{Qdrant.QDRANT__SERVICE__API_KEY}}
```

From outside Railway, use `https://<your domain>` (port 443) with the same key.

## Updates

This template builds from this repo. When the pinned Qdrant version changes on `main`, Railway shows deployers an "update available" notice, and they choose when to apply it. Read [`CHANGELOG.md`](CHANGELOG.md) before you apply an update, and take a snapshot first. Qdrant supports upgrading one minor version at a time.

## Local run

```sh
docker build -t qdrant-railway .
docker run -p 6333:6333 -e QDRANT__SERVICE__API_KEY=change-me -v qdrant-data:/qdrant/data qdrant-railway
```
