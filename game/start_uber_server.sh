#!/bin/zsh
# Launch the CIO UberDOG server (macOS).
# Run from cio-src/game.

GAME_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_BUILD="${ENGINE_BUILD:-/Users/michael/github/CIO/panda3d-darth/build}"
PYTHON="${PYTHON:-/Library/Frameworks/Python.framework/Versions/3.10/bin/python3}"

export PYTHONPATH="$ENGINE_BUILD:$GAME_DIR"

BASE_CHANNEL="${BASE_CHANNEL:-1000000}"
MAX_CHANNELS="${MAX_CHANNELS:-999999}"
STATE_SERVER="${STATE_SERVER:-4002}"
ASTRON_IP="${ASTRON_IP:-127.0.0.1:7031}"
EVENT_LOGGER_IP="${EVENT_LOGGER_IP:-127.0.0.1:7030}"
ACCOUNT_LIMIT="${ACCOUNT_LIMIT:-2}"
ACC_LIMIT_PER_COMP="${ACC_LIMIT_PER_COMP:-2}"
HOLIDAY="${HOLIDAY:-0}"

echo "Starting Cog Invasion Uber Server..."
echo "-----------------------------------"
echo "BASE CHANNEL: $BASE_CHANNEL"
echo "MAX_CHANNELS: $MAX_CHANNELS"
echo "STATE_SERVER: $STATE_SERVER"
echo "ASTRON_IP:    $ASTRON_IP"
echo "EVENT_LOGGER: $EVENT_LOGGER_IP"
echo "-----------------------------------"

cd "$GAME_DIR" || exit 1
exec "$PYTHON" -m src.coginvasion.uber.UberStart \
    --base-channel "$BASE_CHANNEL" \
    --max-channels "$MAX_CHANNELS" --stateserver "$STATE_SERVER" \
    --astron-ip "$ASTRON_IP" --eventlogger-ip "$EVENT_LOGGER_IP" \
    --acc-limit "$ACCOUNT_LIMIT" --acc-limit-per-comp "$ACC_LIMIT_PER_COMP" --holiday "$HOLIDAY"
