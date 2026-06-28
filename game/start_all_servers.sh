#!/bin/zsh
# Launch the full CIO server stack on macOS: Astron, then UberDOG, then AI.
# Each starts in the background with a 5s cooldown so dependencies come up in order.
# Logs go to ./server-logs/. Ctrl-C stops the whole stack.

GAME_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$GAME_DIR" || exit 1

LOG_DIR="$GAME_DIR/server-logs"
mkdir -p "$LOG_DIR"

PIDS=()

cleanup() {
    echo "\nStopping server stack..."
    for pid in "${PIDS[@]}"; do
        kill "$pid" 2>/dev/null
    done
    wait 2>/dev/null
    exit 0
}
trap cleanup INT TERM

echo "=== Starting Astron ==="
"$GAME_DIR/start_astron_server.sh" > "$LOG_DIR/astron.log" 2>&1 &
PIDS+=($!)
sleep 5

echo "=== Starting UberDOG ==="
"$GAME_DIR/start_uber_server.sh" > "$LOG_DIR/uber.log" 2>&1 &
PIDS+=($!)
sleep 5

echo "=== Starting AI ==="
"$GAME_DIR/start_ai_server.sh" > "$LOG_DIR/ai.log" 2>&1 &
PIDS+=($!)

echo "\nAll servers launched. Logs in $LOG_DIR/"
echo "  astron -> $LOG_DIR/astron.log"
echo "  uber   -> $LOG_DIR/uber.log"
echo "  ai     -> $LOG_DIR/ai.log"
echo "Press Ctrl-C to stop the stack."
wait
