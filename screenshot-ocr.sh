#!/usr/bin/env bash

# Define a temporary file for the screenshot
tmpfile=$(mktemp /tmp/screenshot-ocr-XXXXXX.png)

# Use slurp to select a region and grim to take a screenshot of that region,
# then save it to the temporary file
grim -g "$(slurp)" "$tmpfile" && echo "Screenshot saved to $tmpfile"

# Process the image with Tesseract OCR
# Use -l eng to specify English language, add additional languages as needed with +lang2
tesseract "$tmpfile" - -l eng 2>/dev/null | wl-copy

# Send a notification about the copied text
copied_text=$(wl-paste)
truncated_text="${copied_text:0:50}$([ ${#copied_text} -gt 50 ] && echo "..." || echo "")"
notify-send "OCR Complete" "Text copied to clipboard: $truncated_text"

# Keep a copy of the screenshot in Pictures (following your existing pattern)
mv "$tmpfile" "$HOME/Pictures/"