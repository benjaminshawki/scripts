#!/bin/bash

# This script updates waybar workspace button styling based on bell notifications
# It should be called whenever the bell notification file changes

NOTIFICATION_FILE="/tmp/waybar-bell-notifications.json"
WORKSPACE_MODULE_FILE="/tmp/waybar-workspaces-bell.json"

# Function to update waybar workspace module config
update_workspace_styling() {
    # Initialize if files don't exist
    if [[ ! -f $NOTIFICATION_FILE ]]; then
        echo '{"workspaces": []}' > $NOTIFICATION_FILE
    fi
    
    # Get the current bell workspaces
    bell_workspaces=$(cat $NOTIFICATION_FILE | jq -r '.workspaces[]' 2>/dev/null)
    
    # Create a JSON array of workspace numbers with bell class
    workspace_classes="{"
    
    for i in {1..10}; do
        if echo "$bell_workspaces" | grep -q "^$i$"; then
            workspace_classes+="\"$i\": \"bell\","
        fi
    done
    
    # Remove trailing comma and close JSON
    workspace_classes="${workspace_classes%,}}"
    
    # Save to file that waybar can use
    echo "$workspace_classes" > $WORKSPACE_MODULE_FILE
    
    # Signal waybar to update
    pkill -SIGUSR2 waybar
}

# Initial update
update_workspace_styling

# Monitor for changes
while true; do
    inotifywait -e modify $NOTIFICATION_FILE 2>/dev/null || sleep 1
    update_workspace_styling
done