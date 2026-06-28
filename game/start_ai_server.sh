#!/bin/zsh
# Launch the CIO AI (district) server (macOS).
# Run from cio-src/game.
# Pass the base channel as $1 (default 403). Use a higher number for each new district.

GAME_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_BUILD="${ENGINE_BUILD:-/Users/michael/github/CIO/panda3d-darth/build}"
PYTHON="${PYTHON:-/Library/Frameworks/Python.framework/Versions/3.10/bin/python3}"

export PYTHONPATH="$ENGINE_BUILD:$GAME_DIR"

BASE_CHANNEL="${1:-${BASE_CHANNEL:-403}}"
MAX_CHANNELS="${MAX_CHANNELS:-999999}"
STATE_SERVER="${STATE_SERVER:-4002}"
ASTRON_IP="${ASTRON_IP:-127.0.0.1:7031}"
EVENT_LOGGER_IP="${EVENT_LOGGER_IP:-127.0.0.1:7030}"

echo "Starting Cog Invasion AI Server..."
echo "-----------------------------------"
echo "BASE CHANNEL: $BASE_CHANNEL"
echo "MAX_CHANNELS: $MAX_CHANNELS"
echo "STATE_SERVER: $STATE_SERVER"
echo "ASTRON_IP:    $ASTRON_IP"
echo "EVENT_LOGGER: $EVENT_LOGGER_IP"
echo "-----------------------------------"

cd "$GAME_DIR" || exit 1
exec "$PYTHON" -m src.coginvasion.ai.AIStart \
    --base-channel "$BASE_CHANNEL" \
    --max-channels "$MAX_CHANNELS" --stateserver "$STATE_SERVER" \
    --astron-ip "$ASTRON_IP" --eventlogger-ip "$EVENT_LOGGER_IP"
