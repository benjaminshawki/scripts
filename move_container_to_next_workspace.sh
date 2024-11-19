
#!/bin/bash

# Define the maximum workspace number (adjust if you have more or fewer workspaces)
max_workspace=10

# Get the current workspace number
current_workspace=$(swaymsg -t get_workspaces -r | jq '.[] | select(.focused).num')

# Default to workspace 1 if none is found
if [ -z "$current_workspace" ]; then
    current_workspace=1
fi

# Calculate the next workspace number with wrapping
if [ "$current_workspace" -lt "$max_workspace" ]; then
    next_workspace=$((current_workspace + 1))
else
    next_workspace=1
fi

# Move the container to the next workspace
swaymsg move container to workspace number $next_workspace

# Switch focus to the next workspace
swaymsg workspace number $next_workspace
