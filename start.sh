#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

mkdir -p "$WORKDIR"

echo "Generating config..."
rm -f "$WORKDIR/config.toml"

zeroclaw onboard \
  --api-key "$OPENROUTER_API_KEY" \
  --provider openrouter \
  --memory sqlite

sed -i 's|default_model = ".*"|default_model = "qwen/qwen3.6-plus"|' "$WORKDIR/config.toml"

# 🔥 ONLY patch gateway safely
sed -i '/\[gateway\]/,/^\[/ s/host = "127.0.0.1"/host = "0.0.0.0"/' "$WORKDIR/config.toml"
sed -i '/\[gateway\]/,/^\[/ s/allow_public_bind = false/allow_public_bind = true/' "$WORKDIR/config.toml"

# DO NOT touch other ports anymore ❌

chmod 600 "$WORKDIR/config.toml" || true

echo "Launching Zeroclaw daemon..."

exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"