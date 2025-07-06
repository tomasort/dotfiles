#!/bin/bash

# Get current workspace from AeroSpace environment variable
current_workspace=$AEROSPACE_FOCUSED_WORKSPACE

# Exit if no workspace is provided
if [ -z "$current_workspace" ]; then
    exit 0
fi

# Move PiP windows to current workspace (handles both "Picture-in-Picture" and "Picture in Picture")
pip_windows=$(/usr/local/bin/aerospace list-windows --all 2>/dev/null | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}')

if [ -n "$pip_windows" ]; then
    echo "$pip_windows" | while read window_id; do
        if [ -n "$window_id" ]; then
            /usr/local/bin/aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace" 2>/dev/null
        fi
    done
fi
