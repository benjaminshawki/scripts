#!/bin/bash

# This script outputs JSON for waybar custom module
NOTIFICATION_FILE="/tmp/waybar-bell-notifications.json"

# Initialize if file doesn't exist
if [[ ! -f $NOTIFICATION_FILE ]]; then
    echo '{"workspaces": []}' > $NOTIFICATION_FILE
fi

# Read the notification file
notifications=$(cat $NOTIFICATION_FILE)
workspaces=$(echo "$notifications" | jq -r '.workspaces | join(" ")')

if [[ -n $workspaces ]]; then
    echo "{\"text\": \"🔔 $workspaces\", \"class\": \"bell-active\", \"tooltip\": \"Tmux bell on workspace(s): $workspaces\"}"
else
    echo "{\"text\": \"\", \"class\": \"bell-inactive\"}"
fi