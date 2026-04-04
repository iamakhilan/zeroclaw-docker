#!/bin/bash
set -e

echo "Starting Zeroclaw..."

mkdir -p /root/.zeroclaw

cat <<EOF > /root/.zeroclaw/config.toml
[providers.openrouter]
api_key = "$OPENROUTER_API_KEY"
EOF

zeroclaw daemon --host 0.0.0.0 --port 10000