#!/bin/bash

# emoji-picker.sh - Emoji picker for Sway using fzf
# Uses the emojis.csv file to create an interactive emoji picker
# Types the selected emoji at cursor position without affecting clipboard

# Enable debug logging
set -x

# Log file for debugging
DEBUG_LOG="/tmp/emoji-picker-debug.log"
exec > >(tee -a "$DEBUG_LOG") 2>&1

echo "Starting emoji picker at $(date)"

# Path to the emoji CSV file
EMOJI_FILE="/home/benjamin/bin/emoji-picker/emojis.csv"

# Check if the file exists
if [ ! -f "$EMOJI_FILE" ]; then
    notify-send "Error" "Emoji file not found: $EMOJI_FILE"
    echo "Error: Emoji file not found: $EMOJI_FILE"
    exit 1
fi

# Check if wtype is installed (for inserting text at cursor)
if ! command -v wtype &> /dev/null; then
    notify-send "Error" "wtype is not installed. Please install wtype package."
    echo "Error: wtype is not installed"
    exit 1
fi

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    notify-send "Error" "fzf is not installed. Please install fzf package."
    echo "Error: fzf is not installed"
    exit 1
fi

echo "Dependencies check passed"

# Create a simpler approach - create a temporary script that will be executed
TEMP_SCRIPT=$(mktemp)
echo "Created temp script: $TEMP_SCRIPT"

# Process a small sample of the emoji data for testing
emoji_sample=$(head -n 10 "$EMOJI_FILE" | awk -F ', ' '{gsub(/"/, "", $2); print $1 "\t" $2}')
echo "Emoji sample: $emoji_sample"

# Write a simplified temp script
cat > "$TEMP_SCRIPT" << 'EOF'
#!/bin/bash

# Process the emoji file
EMOJI_FILE="/home/benjamin/bin/emoji-picker/emojis.csv"
emoji_data=$(awk -F ', ' '{gsub(/"/, "", $2); print $1 "\t" $2}' "$EMOJI_FILE")

# Run FZF with minimal options
selected=$(echo -e "$emoji_data" | fzf --reverse)

# Check if an emoji was selected
if [ -n "$selected" ]; then
    # Extract just the emoji character
    emoji=$(echo "$selected" | awk '{print $1}')
    
    # Type the emoji at cursor position 
    wtype "$emoji"
    
    # Notify user
    notify-send "Emoji inserted" "$emoji"
fi
EOF

# Make the script executable
chmod +x "$TEMP_SCRIPT"
echo "Temp script is now executable"

# Launch in a floating Alacritty window
echo "Launching Alacritty with simplified script"

exec swaymsg -t command exec "alacritty \
    --class=emoji-picker \
    --title='Emoji Picker Debug' \
    -e $TEMP_SCRIPT"