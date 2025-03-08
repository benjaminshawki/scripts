#!/usr/bin/env bash

# Listen for window focus events
swaymsg -t subscribe -m '[ "window" ]' | jq --unbuffered '
  select(.change == "focus") | .container.app_id' |
while read app_id; do
  # If the new focus is not on the launcher or emoji-picker, close them
  if [[ $app_id != "\"launcher\"" && $app_id != "\"emoji-picker\"" ]]; then
    swaymsg '[app_id="^launcher$|^emoji-picker$"]' kill
  fi
done;
