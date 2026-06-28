#!/bin/zsh
# Launch the Astron daemon (macOS).
# Run from cio-src/game.

ASTROND="${ASTROND:-/Users/michael/github/CIO/Astron/build/astrond}"
LOGLEVEL="${LOGLEVEL:-warning}"

echo "Starting Astron server (loglevel=$LOGLEVEL)..."
cd "$(dirname "$0")/astron" || exit 1
exec "$ASTROND" --loglevel "$LOGLEVEL" config/astrond.yml
