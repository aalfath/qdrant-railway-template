#!/usr/bin/env bash
# Railway wrapper for the official Qdrant entrypoint.
set -euo pipefail

# Railway routes the public domain and its health check to $PORT.
export QDRANT__SERVICE__HTTP_PORT="${QDRANT__SERVICE__HTTP_PORT:-${PORT:-6333}}"

# Refuse to start without an API key: a Qdrant on a public domain with no key is open to anyone.
if [ -z "${QDRANT__SERVICE__API_KEY:-}" ] && [ "${QDRANT_ALLOW_NO_API_KEY:-false}" != "true" ]; then
  echo "QDRANT__SERVICE__API_KEY is empty. Set it (the template generates one) or set QDRANT_ALLOW_NO_API_KEY=true." >&2
  exit 1
fi

mkdir -p "$(dirname "$QDRANT__STORAGE__STORAGE_PATH")" "$QDRANT__STORAGE__STORAGE_PATH" "$QDRANT__STORAGE__SNAPSHOTS_PATH"

cd /qdrant
exec ./entrypoint.sh "$@"
