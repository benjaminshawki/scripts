#!/usr/bin/env bash

# Get the geometry of the currently focused window
geometry=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n 1 | tr -d '"')

# Define a temporary file for the screenshot
tmpfile=$(mktemp /tmp/screenshot-window-ocr-XXXXXX.png)

# Check if the geometry variable is set
if [ -n "$geometry" ]; then
    # Use grim to take a screenshot of the focused window, then save it to the temporary file
    grim -g "$geometry" "$tmpfile" && echo "Screenshot saved to $tmpfile"

    # Process the image with Tesseract OCR
    # Use -l eng to specify English language, add additional languages as needed
    tesseract "$tmpfile" - -l eng 2>/dev/null | wl-copy

    # Send a notification about the copied text
    copied_text=$(wl-paste)
    truncated_text="${copied_text:0:50}$([ ${#copied_text} -gt 50 ] && echo "..." || echo "")"
    notify-send "OCR Complete" "Text copied to clipboard: $truncated_text"

    # Keep a copy of the screenshot in Pictures (following your existing pattern)
    mv "$tmpfile" "$HOME/Pictures/"
else
    echo "Failed to capture the focused window. Please make sure a window is focused."
fi