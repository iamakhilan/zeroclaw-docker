#!/bin/bash
set -euo pipefail

echo "Starting Zeroclaw..."

PORT="${PORT:-10000}"
WORKDIR="/root/.zeroclaw"

mkdir -p "$WORKDIR"

echo "Writing full config..."

cat <<EOF > "$WORKDIR/config.toml"
[providers.openrouter]
api_key = "$OPENROUTER_API_KEY"
default_temperature = 0.7

[agent]
name = "zeroclaw-agent"

[memory]
backend = "sqlite"

[gateway]
allow_public_bind = true
EOF

chmod 600 "$WORKDIR/config.toml" || true

echo "Launching Zeroclaw daemon..."

exec zeroclaw daemon --host 0.0.0.0 --port "$PORT"