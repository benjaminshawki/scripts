#!/usr/bin/env bash

# Get the names and details of the outputs
outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | "\(.name) \(.current_mode.width)x\(.current_mode.height)"')

# Internal and external display detection
# Assuming the internal display is eDP-1. Adjust if necessary.
internal_display="eDP-1"
external_display=""
external_height=0
external_width=0
internal_width=0

while IFS= read -r line; do
  display=$(echo $line | awk '{print $1}')
  resolution=$(echo $line | awk '{print $2}')
  width=$(echo $resolution | cut -d"x" -f1)
  height=$(echo $resolution | cut -d"x" -f2)
  
  if [ "$display" != "$internal_display" ]; then
    external_display=$display
    external_height=$height
    external_width=$width
  else
    internal_width=$width
  fi
done <<< "$outputs"

if [ -n "$external_display" ]; then
    # Calculate the position for the internal display to be directly below the external display
    position_internal_y=$(($external_height))
    
    # Calculate horizontal position to center the internal display beneath the external display
    position_internal_x=$(( (external_width - internal_width) / 2 ))
    if [ $position_internal_x -lt 0 ]; then
        position_internal_x=0
    fi

    swaymsg output "$internal_display" pos $position_internal_x $position_internal_y
    swaymsg output "$external_display" pos 0 0
    echo "Configured $external_display above and centered with $internal_display."
else
    echo "No external display detected or configuration issue."
fi

