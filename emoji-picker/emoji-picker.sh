#!/bin/bash

# emoji-picker.sh - Emoji picker for Sway using fzf
# Uses the emojis.csv file to create an interactive emoji picker
# Copies the selected emoji to clipboard

# Path to the emoji CSV file
EMOJI_FILE="$HOME/bin/emoji-picker/emojis.csv"

# Check if the file exists
if [ ! -f "$EMOJI_FILE" ]; then
	notify-send "Error" "Emoji file not found: $EMOJI_FILE"
	exit 1
fi

# Check if wl-copy is installed (for clipboard)
if ! command -v wl-copy &>/dev/null; then
	notify-send "Error" "wl-copy is not installed. Please install wl-clipboard package."
	exit 1
fi

# Check if fzf is installed
if ! command -v fzf &>/dev/null; then
	notify-send "Error" "fzf is not installed. Please install fzf package."
	exit 1
fi

# Process the emoji file to a format suitable for fzf
# Format: emoji  description
emoji_data=$(awk -F ', ' '{gsub(/"/, "", $2); print $1 "\t" $2}' "$EMOJI_FILE")

# Create a temporary script
TEMP_SCRIPT=$(mktemp)

# Write the script content
cat >"$TEMP_SCRIPT" <<'EOF'
#!/bin/bash

# Process the emoji file
EMOJI_FILE="/home/benjamin/bin/emoji-picker/emojis.csv"
emoji_data=$(awk -F ', ' '{gsub(/"/, "", $2); print $1 "\t" $2}' "$EMOJI_FILE")

# Run FZF with options
selected=$(echo -e "$emoji_data" | fzf --reverse --border rounded \
  --prompt "Find emoji: " \
  --preview "echo -e {1}" \
  --preview-window up:1 \
  --header "Select an emoji (press ESC to cancel)" \
  --info inline)

# Check if an emoji was selected
if [ -n "$selected" ]; then
    # Extract just the emoji character
    emoji=$(echo "$selected" | awk '{print $1}')
    
    # Copy to clipboard
    echo -n "$emoji" | wl-copy
    
    # Notify user
    notify-send "Emoji copied to clipboard" "$emoji"
fi
EOF

# Make the script executable
chmod +x "$TEMP_SCRIPT"

# Launch in a floating Alacritty window
exec swaymsg -t command exec "alacritty \
    --class=emoji-picker \
    --title='Emoji Picker' \
    -e $TEMP_SCRIPT"
