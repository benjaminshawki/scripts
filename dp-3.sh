#!/usr/bin/env bash

# Function to get monitor position and resolution
get_monitor_info() {
    swaymsg -t get_outputs | jq -r --arg monitor "$1" '.[] | select(.name == $monitor) | "\(.rect.x) \(.rect.y) \(.rect.width) \(.rect.height)"'
}

# Apply settings for DP-3 if connected
monitor_info=$(get_monitor_info "DP-3")
if [[ $monitor_info ]]; then
    read -r dp_x dp_y dp_width dp_height <<< "$monitor_info"

    # Position eDP-1 directly below DP-3
    y_offset=$(($dp_y + $dp_height)) # Use DP-3's height to calculate Y offset

    # Center eDP-1 relative to DP-3
    # Get eDP-1 resolution
    edp_info=$(get_monitor_info "eDP-1")
    read -r edp_x edp_y edp_width edp_height <<< "$edp_info"
    
    # Assuming eDP-1 resolution and scaling factor is known and consistent
    # Adjust eDP-1 width based on its scale to calculate centering correctly
    scaled_edp_width=$(($edp_width / 2)) # Adjust this if eDP-1 scale is different

    # Calculate X offset to center eDP-1 below DP-3
    x_offset=$((dp_x + (dp_width / 2) - (scaled_edp_width / 2)))
else
    echo "DP-3 not connected or not detected."
fi

# Set position for eDP-1 dynamically
if [[ -n $y_offset ]]; then
    swaymsg output eDP-1 pos $x_offset $y_offset
    echo "eDP-1 positioned below DP-3 centered."
fi
