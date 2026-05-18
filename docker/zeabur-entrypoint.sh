#!/bin/sh
set -eu

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8990}"
REGION="${REGION:-us-east-1}"
TLS_BACKEND="${TLS_BACKEND:-rustls}"
DEFAULT_ENDPOINT="${DEFAULT_ENDPOINT:-ide}"
ADMIN_API_KEY="${ADMIN_API_KEY:-}"

if [ -z "${API_KEY:-}" ]; then
  echo "ERROR: API_KEY is required. Set it in Zeabur environment variables."
  exit 1
fi

mkdir -p /app/config

cat > /app/config/config.json <<EOF
{
  "host": "$HOST",
  "port": $PORT,
  "apiKey": "$API_KEY",
  "tlsBackend": "$TLS_BACKEND",
  "region": "$REGION",
  "adminApiKey": "$ADMIN_API_KEY",
  "defaultEndpoint": "$DEFAULT_ENDPOINT"
}
EOF

if [ -n "${CREDENTIALS_JSON:-}" ]; then
  printf '%s' "$CREDENTIALS_JSON" > /app/config/credentials.json
else
  printf '[]\n' > /app/config/credentials.json
fi

echo "Generated /app/config/config.json for Zeabur"
exec /app/kiro-rs -c /app/config/config.json --credentials /app/config/credentials.json
