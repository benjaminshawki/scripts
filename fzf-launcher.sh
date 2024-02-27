#!/bin/bash
alacritty_class="launcher"
alacritty_pid=$!

# Listen for focus change events
swaymsg -t subscribe -m '[ "window" ]' | jq --unbuffered --arg alacritty_class "$alacritty_class" --arg alacritty_pid "$alacritty_pid" '
select(.change == "focus") | .container | select(.app_id != $alacritty_class and .pid != ($alacritty_pid | tonumber)) | .pid' | while read pid; do
    swaymsg "[app_id=\"$alacritty_class\"] kill"
    break
done
