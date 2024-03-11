#!/usr/bin/env bash

# Define a temporary file for the screenshot
tmpfile=$(mktemp /tmp/screenshot-XXXXXX.png)

# Use slurp to select a region and grim to take a screenshot of that region,
# then save it to the temporary file
grim -g "$(slurp)" "$tmpfile" && echo "Screenshot saved to $tmpfile"

# Copy the screenshot to the clipboard
wl-copy < "$tmpfile"

# Optionally, move the screenshot to your Pictures directory
mv "$tmpfile" "$HOME/Pictures/"
