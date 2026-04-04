#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

mkdir -p "$WORKDIR"

# Run onboarding only once
if [ ! -f "$WORKDIR/config.toml" ]; then
  echo "Running Zeroclaw onboarding..."

  zeroclaw onboard \
    --api-key "$OPENROUTER_API_KEY" \
    --provider openrouter \
    --memory sqlite
fi

# Allow public binding (required for Render)
if ! grep -q "allow_public_bind" "$WORKDIR/config.toml"; then
  echo "" >> "$WORKDIR/config.toml"
  echo "[gateway]" >> "$WORKDIR/config.toml"
  echo "allow_public_bind = true" >> "$WORKDIR/config.toml"
fi

chmod 600 "$WORKDIR/config.toml" || true

echo "Launching Zeroclaw daemon..."

exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"