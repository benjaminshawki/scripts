#!/bin/bash

# emoji-picker.sh - Emoji picker for Sway using fzf
# Uses the emojis.csv file to create an interactive emoji picker
# Copies selected emoji to clipboard using wl-copy

# Path to the emoji CSV file
EMOJI_FILE="/home/benjamin/bin/emoji-picker/emojis.csv"

# Check if the file exists
if [ ! -f "$EMOJI_FILE" ]; then
    notify-send "Error" "Emoji file not found: $EMOJI_FILE"
    exit 1
fi

# Check if wl-copy is installed
if ! command -v wl-copy &> /dev/null; then
    notify-send "Error" "wl-copy is not installed. Please install wl-clipboard package."
    exit 1
fi

# Process the emoji file to a format suitable for fzf
# Format: emoji  description
emoji_data=$(awk -F ', ' '{gsub(/"/, "", $2); print $1 "\t" $2}' "$EMOJI_FILE")

# Use fzf to select emoji
selected=$(echo -e "$emoji_data" | fzf --reverse --border rounded \
    --prompt "Find emoji: " \
    --preview "echo -e {1}" \
    --preview-window "up:1" \
    --height "50%" \
    --header "Select an emoji (press ESC to cancel)" \
    --info inline \
    --color "bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1" \
    | awk '{print $1}')

# If emoji selected, copy to clipboard
if [ -n "$selected" ]; then
    echo -n "$selected" | wl-copy
    notify-send "Emoji copied" "$selected"
fi