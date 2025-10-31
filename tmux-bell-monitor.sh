#!/bin/bash

# Socket file for bell notifications
SOCKET="/tmp/tmux-bell-monitor.sock"

# Colors
ORANGE="#FFAA00"
RESET="#EBDBB2"

# Function to send notification to waybar
notify_waybar() {
    workspace=$1
    
    # Create a JSON file that waybar can read
    echo "{\"workspaces\": [$workspace], \"color\": \"$ORANGE\"}" > /tmp/waybar-bell-notifications.json
    
    # Send signal to waybar to update
    pkill -RTMIN+8 waybar
}

# Clear notification
clear_notification() {
    echo "{\"workspaces\": [], \"color\": \"$RESET\"}" > /tmp/waybar-bell-notifications.json
    pkill -RTMIN+8 waybar
}

# Monitor tmux bells
monitor_bells() {
    # Clear any existing notifications on startup
    clear_notification
    
    while true; do
        # Get all tmux sessions
        tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
            # Check each window in each session for bell
            tmux list-windows -t "$session" -F "#{window_index} #{window_flags}" 2>/dev/null | while read -r window_index window_flags; do
                if [[ $window_flags == *"!"* ]]; then
                    # Bell detected - get the workspace where this window is
                    # First get the pane's tty
                    tty=$(tmux list-panes -t "${session}:${window_index}" -F "#{pane_tty}" | head -1)
                    
                    # Find the workspace containing this tty
                    workspace=$(swaymsg -t get_tree | jq -r ".nodes[] | select(.type==\"workspace\") | select(.nodes[].nodes[].name | test(\"$tty\")) | .name")
                    
                    if [[ -n $workspace ]]; then
                        notify_waybar "$workspace"
                    fi
                fi
            done
        done
        
        sleep 1
    done
}

# Handle signals
trap clear_notification EXIT

# Start monitoring
monitor_bells