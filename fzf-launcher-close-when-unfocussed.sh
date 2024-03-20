#!/usr/bin/env bash

# Listen for window focus events
swaymsg -t subscribe -m '[ "window" ]' | jq --unbuffered '
  select(.change == "focus") | .container.app_id' |
while read app_id; do
  # If the new focus is not on the launcher, close the launcher
  if [[ $app_id != "\"launcher\"" ]]; then
    swaymsg '[app_id="^launcher$"]' kill
  fi
done

