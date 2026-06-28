#!/bin/zsh
# Launch the Cog Invasion Online client (macOS).
# Run from cio-src/game. Mirrors start_ci.bat, plus the macOS GL overrides.

GAME_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_BUILD="${ENGINE_BUILD:-/Users/michael/github/CIO/panda3d-darth/build}"
PYTHON="${PYTHON:-/Library/Frameworks/Python.framework/Versions/3.10/bin/python3}"

export PYTHONPATH="$ENGINE_BUILD:$GAME_DIR"

# Account / server config (same values as start_ci.bat). Single-quote the token:
# it contains a '$' that must not be expanded by the shell.
export GAME_SERVER="${GAME_SERVER:-127.0.0.1:7032}"
export GAME_VERSION="${GAME_VERSION:-1.1.0}"
export LOGIN_TOKEN="${LOGIN_TOKEN:-asdasd\$asdasdASfdasdgdaAsassa4234QW34324436REGdfnjGFb}"
export RESOURCE_ENCRYPTION="${RESOURCE_ENCRYPTION:-cio-03-06-16_lsphases}"

# Prompt for the username (default: testuser), like start_ci.bat.
if [ -z "$ACCOUNT_NAME" ]; then
    printf 'Username [testuser]: '
    read reply
    export ACCOUNT_NAME="${reply:-testuser}"
fi

cd "$GAME_DIR" || exit 1

# config/config_client.prc forces 'load-display pandadx9' (Windows). macOS needs
# the GL pipe and an OpenGL 4.1 core context, so override before startup. An
# explicit loadPrcFileData takes priority over the later loadPrcFile in CIStart.
exec "$PYTHON" -B -c '
from panda3d.core import loadPrcFileData
loadPrcFileData("macos-client", "load-display pandagl\naux-display pandagl\ngl-version 4 1")
import src.coginvasion.base.CIStartGlobal
'
