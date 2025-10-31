#!/bin/bash

# This script should be called by tmux when a bell occurs
# It identifies the workspace containing the tmux session and notifies waybar

ORANGE="#FFAA00"
NOTIFICATION_FILE="/tmp/waybar-bell-notifications.json"

# Get the current tmux session
session=$(tmux display-message -p '#S')
window=$(tmux display-message -p '#I')
pane_pid=$(tmux display-message -p '#{pane_pid}')

# Find the workspace containing this process
workspace=""
if [[ -n $pane_pid ]]; then
    # Get all workspaces and search for the one containing our PID
    workspace=$(swaymsg -t get_workspaces | jq -r ".[] | select(.nodes[]?.pid == $pane_pid or .nodes[]?.nodes[]?.pid == $pane_pid) | .name")
    
    if [[ -z $workspace ]]; then
        # Alternative method: search by app_id containing alacritty
        workspace=$(swaymsg -t get_tree | jq -r '
            def search: 
                if .pid == '$pane_pid' then .workspace 
                elif .nodes then .nodes[] | search
                else empty
                end;
            search' | head -1)
    fi
fi

# If we found the workspace, update the notification file
if [[ -n $workspace ]]; then
    # Read existing notifications
    existing="{}"
    if [[ -f $NOTIFICATION_FILE ]]; then
        existing=$(cat $NOTIFICATION_FILE)
    fi
    
    # Add this workspace to the list
    updated=$(echo "$existing" | jq ".workspaces += [\"$workspace\"] | .workspaces |= unique")
    echo "$updated" > $NOTIFICATION_FILE
    
    # Send signal to waybar to update
    pkill -RTMIN+8 waybar
fi