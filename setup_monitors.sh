#!/usr/bin/env bash

# exec > /var/log/reload_sway_debug.log 2>&1
echo "Running setup_monitors.sh at $(date)"

# Get the names and details of the outputs including serial numbers
#
outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | "\(.name) \(.serial) \(.current_mode.width)x\(.current_mode.height)"')

# Internal display and LG UltraGear serial
internal_display="eDP-1"
lg_display_serial="201NTWG86721"
# lg_display_serial="DP-1"

# Flags and variables
disable_internal=0
external_display=""
external_width=0
external_height=0


while IFS= read -r line; do
  display=$(echo $line | awk '{print $1}')
  serial=$(echo $line | awk '{print $2}')
  resolution=$(echo $line | awk '{print $3}')
  width=$(echo $resolution | cut -d"x" -f1)
  height=$(echo $resolution | cut -d"x" -f2)

	echo $display
	echo $serial
	echo $resolution
  

	# Display seems to work for usbc, however usbc over displayport doesnt work atm
  # if [ "$serial" == "$lg_display_serial" ]; then
  if [ "$serial" == "$lg_display_serial" ]; then
    disable_internal=1
    # Optionally, save external display info if needed
    external_display=$display
    external_width=$width
    external_height=$height
  fi


	if [ "$display" != "eDP-1" ]; then
		external_display=$display
	fi 

done <<< "$outputs"

echo "disable_internal: $disable_internal"
echo "external_display: $external_display"
echo "external_width: $external_width"


if [ $disable_internal -eq 1 ]; then
    # Disable the internal display if the specific LG UltraGear monitor is connected
    swaymsg output "$internal_display" disable
    echo "Disabled $internal_display as LG UltraGear monitor with serial $lg_display_serial is connected."

    # Configure the LG UltraGear display
    if [ -n "$external_display" ]; then

        swaymsg output "$external_display" mode 3440x1440@160Hz pos 0 0
        echo "Configured $external_display."
    fi
else
    # Re-enable the internal display if the specific LG UltraGear monitor is not connected
		centered_width=$(((external_width - 1920) / 2))
    swaymsg output "$internal_display" enable
    swaymsg output "$internal_display" pos $centered_width $external_height
    echo "Enabled $internal_display as no LG UltraGear monitor with serial $lg_display_serial is connected."

		if [ -n "$external_display" ]; then
				swaymsg output "$external_display" pos 0 0
				echo "Configured $external_display."
		fi
fi

#
# # Get the names and details of the outputs
# outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | "\(.name) \(.current_mode.width)x\(.current_mode.height)"')
#
#
# # Internal and external display detection
# # Assuming the internal display is eDP-1. Adjust if necessary.
# internal_display="eDP-1"
# external_display=""
# external_height=0
# external_width=0
# internal_width=0
#
# lg_display_serial="201NTWG86721"
#
# while IFS= read -r line; do
#   display=$(echo $line | awk '{print $1}')
#   echo $display
#   resolution=$(echo $line | awk '{print $2}')
#   width=$(echo $resolution | cut -d"x" -f1)
#   height=$(echo $resolution | cut -d"x" -f2)
#   
#   if [ "$display" != "$internal_display" ]; then
#     external_display=$display
#     external_height=$height
#     external_width=$width
#   else
#     internal_width=$width
#   fi
# done <<< "$outputs"
#
# if [ -n "$external_display" ]; then
#     # Calculate the position for the internal display to be directly below the external display
#     position_internal_y=$(($external_height))
#     
#     # Calculate horizontal position to center the internal display beneath the external display
#     position_internal_x=$(( (external_width - internal_width) / 2 ))
#     if [ $position_internal_x -lt 0 ]; then
#         position_internal_x=0
#     fi
#
#     swaymsg output "$internal_display" pos $position_internal_x $position_internal_y
#     swaymsg output "$external_display" pos 0 0
#     echo "Configured $external_display above and centered with $internal_display."
# else
#     echo "No external display detected or configuration issue."
# fi
#
#
