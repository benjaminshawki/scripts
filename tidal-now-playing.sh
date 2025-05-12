#\!/bin/bash

# Get player status and information using playerctl
STATUS=$(playerctl status 2>/dev/null)
if [ $? -ne 0 ]; then
    echo '{"text": "", "class": "no-player", "tooltip": "No media players running"}'
    exit 0
fi

# Get current track information
ARTIST=$(playerctl metadata artist 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)

# Format text output based on playing/paused status
if [ "$STATUS" == "Playing" ]; then
    ICON="♪"
    CLASS="playing"
else
    ICON="⏸"
    CLASS="paused"
fi

# Create display with artist and title
if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
    DISPLAY="$ARTIST - $TITLE"
    # Truncate if too long
    if [ ${#DISPLAY} -gt 40 ]; then
        DISPLAY="${DISPLAY:0:37}..."
    fi
else
    DISPLAY="$TITLE"
fi

# Output JSON for Waybar
echo "{\"text\": \"$ICON $DISPLAY\", \"class\": \"$CLASS\", \"tooltip\": \"$ARTIST - $TITLE\"}"
