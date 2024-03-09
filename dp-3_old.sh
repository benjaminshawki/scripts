#!/bin/bash

# Get the current output information
outputs=$(swaymsg -t get_outputs | jq -c '.[] | select(.name == "DP-3")')

# Check if the monitor is connected and apply scaling
echo "$outputs" | grep -q "HP U32" && \
    swaymsg output DP-3 scale 1.75

# Add additional commands as needed, for example, setting the resolution
# swaymsg output DP-3 resolution 3840x2160

