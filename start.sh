#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

mkdir -p "$WORKDIR"

# Generate config fresh (correct schema always)
echo "Generating config..."
rm -f "$WORKDIR/config.toml"

zeroclaw onboard \
  --api-key "$OPENROUTER_API_KEY" \
  --provider openrouter \
  --memory sqlite

# 🔥 Fix gateway for Render (THIS was your main issue)
sed -i 's/host = "127.0.0.1"/host = "0.0.0.0"/' "$WORKDIR/config.toml"
sed -i 's/allow_public_bind = false/allow_public_bind = true/' "$WORKDIR/config.toml"

# Ensure correct port
sed -i "s/port = .*/port = $PORT/" "$WORKDIR/config.toml"

chmod 600 "$WORKDIR/config.toml" || true

echo "Launching Zeroclaw daemon..."

exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"