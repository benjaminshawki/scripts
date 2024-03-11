#!/usr/bin/env bash

# Get the geometry of the currently focused window
geometry=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n 1 | tr -d '"')

# Define a temporary file for the screenshot
tmpfile=$(mktemp /tmp/screenshot-window-XXXXXX.png)

# Check if the geometry variable is set
if [ -n "$geometry" ]; then
    # Use grim to take a screenshot of the focused window, then save it to the temporary file
    grim -g "$geometry" "$tmpfile" && echo "Screenshot saved to $tmpfile"

    # Copy the screenshot to the clipboard
    wl-copy < "$tmpfile"

    # Optionally, move the screenshot to your Pictures directory
    mv "$tmpfile" "$HOME/Pictures/"
else
    echo "Failed to capture the focused window. Please make sure a window is focused."
fi
