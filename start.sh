#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

mkdir -p "$WORKDIR"

# Always regenerate config cleanly
echo "Generating config via onboarding..."

rm -f "$WORKDIR/config.toml"

# Remove the --once flag since it doesn't exist
zeroclaw onboard \
  --api-key "$OPENROUTER_API_KEY" \
  --provider openrouter \
  --memory sqlite

# Now safely patch gateway
echo "Enabling public gateway..."

cat <<EOF >> "$WORKDIR/config.toml"

[gateway]
allow_public_bind = true
EOF

echo "Launching Zeroclaw daemon..."

exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"