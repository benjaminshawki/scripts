#!/bin/bash

# This script monitors bell notifications and updates waybar workspace classes

NOTIFICATION_FILE="/tmp/waybar-bell-notifications.json"
WORKSPACE_BELL_FILE="/tmp/waybar-workspace-bells.css"

# Create initial CSS file
echo "" > $WORKSPACE_BELL_FILE

while true; do
    if [[ -f $NOTIFICATION_FILE ]]; then
        # Get workspaces with bells
        workspaces=$(cat $NOTIFICATION_FILE | jq -r '.workspaces[]' 2>/dev/null)
        
        # Generate CSS
        css=""
        for ws in $workspaces; do
            css+="#workspaces button:nth-child($ws) { background-color: #FFAA00 !important; color: #000000 !important; animation: pulse 1s infinite; }\n"
        done
        
        # Write CSS if changed
        current_css=$(cat $WORKSPACE_BELL_FILE 2>/dev/null)
        if [[ "$css" != "$current_css" ]]; then
            echo -e "$css" > $WORKSPACE_BELL_FILE
            # Signal waybar to reload
            pkill -RTMIN+8 waybar
        fi
    fi
    
    sleep 1
done