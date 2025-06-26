#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/kitty"

if [ -S "$SOCKET" ]; then
    # Kitty is already running — launch a new tab in the same window
    kitty @ --to "unix:$SOCKET" launch --type=tab --cwd=current
else
    # Start kitty and have it listen on the socket
    kitty --listen-on "unix:$SOCKET"
fi
