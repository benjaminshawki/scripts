#!/bin/bash

# This script is called by tmux when a bell occurs
# It identifies the workspace and updates waybar

NOTIFICATION_FILE="/tmp/waybar-bell-notifications.json"

# Get the tmux pane that triggered the bell
pane_tty=$(tmux display-message -p '#{pane_tty}')
session=$(tmux display-message -p '#{session_name}')
window=$(tmux display-message -p '#{window_index}')

# Find which sway workspace contains this tmux pane
workspace=""

# Method 1: Find by matching the tty device
workspace=$(swaymsg -t get_tree | jq -r --arg tty "$pane_tty" '
    .. | objects | 
    select(.app_id == "Alacritty" or .app_id == "alacritty") |
    select(.pid) |
    if .name then
        . as $node |
        (try (.workspace // empty) catch empty) as $ws |
        if $ws then $ws else empty end
    else empty end
' | grep -v null | sort -u | head -1)

# Method 2: If not found, try finding by window title containing session name
if [[ -z $workspace ]]; then
    workspace=$(swaymsg -t get_tree | jq -r --arg session "$session" '
        .. | objects |
        select(.name | test($session)) |
        (try (.workspace // empty) catch empty) as $ws |
        if $ws then $ws else empty end
    ' | grep -v null | sort -u | head -1)
fi

# Method 3: Get the current active workspace as fallback
if [[ -z $workspace ]]; then
    workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name')
fi

# Update the notification file
if [[ -n $workspace ]]; then
    # Initialize file if it doesn't exist
    if [[ ! -f $NOTIFICATION_FILE ]]; then
        echo '{"workspaces": []}' > $NOTIFICATION_FILE
    fi
    
    # Add workspace to the list (avoiding duplicates)
    cat $NOTIFICATION_FILE | jq ".workspaces += [\"$workspace\"] | .workspaces |= unique" > ${NOTIFICATION_FILE}.tmp
    mv ${NOTIFICATION_FILE}.tmp $NOTIFICATION_FILE
    
    # Signal waybar to update
    pkill -RTMIN+8 waybar
fi