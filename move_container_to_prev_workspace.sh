#!/bin/bash

# Define the maximum workspace number (adjust if you have more or fewer workspaces)
max_workspace=10

# Get the current workspace number
current_workspace=$(swaymsg -t get_workspaces -r | jq '.[] | select(.focused).num')

# Default to workspace 1 if none is found
if [ -z "$current_workspace" ]; then
    current_workspace=1
fi

# Calculate the previous workspace number with wrapping
if [ "$current_workspace" -gt 1 ]; then
    prev_workspace=$((current_workspace - 1))
else
    prev_workspace=$max_workspace
fi

# Move the container to the previous workspace
swaymsg move container to workspace number $prev_workspace

# Switch focus to the previous workspace
swaymsg workspace number $prev_workspace
