#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

# Create config directory
mkdir -p "$WORKDIR"

# Run onboarding ONLY if config doesn't exist
if [ ! -f "$WORKDIR/config.toml" ]; then
  echo "Running Zeroclaw onboarding..."

  zeroclaw onboard \
    --api-key "$OPENROUTER_API_KEY" \
    --provider openrouter \
    --memory sqlite
fi

# Fix permissions (optional but removes warning)
chmod 600 "$WORKDIR/config.toml" || true

echo "Launching Zeroclaw daemon..."

# Start Zeroclaw
exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"