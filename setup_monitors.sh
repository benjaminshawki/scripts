#!/usr/bin/env bash

LOCKFILE="/tmp/setup_monitors.lock"
exec 200>"$LOCKFILE"
flock -n 200 || exit 0

sleep 1

source "$HOME/dotfiles/sway/profiles/monitors.conf"

outputs_json=$(swaymsg -t get_outputs)

external_count=$(echo "$outputs_json" | jq -r '[.[] | select(.name != "eDP-1")] | length')

if [ "$external_count" -eq 0 ]; then
    profile_internal_only
    exit 0
fi

echo "$outputs_json" | jq -r '.[] | select(.name != "eDP-1") | @json' | while read -r output; do
    name=$(echo "$output" | jq -r '.name')
    serial=$(echo "$output" | jq -r '.serial')
    model=$(echo "$output" | jq -r '.model')
    width=$(echo "$output" | jq -r '.current_mode.width')
    height=$(echo "$output" | jq -r '.current_mode.height')

    profile=$(detect_profile "$serial" "$model")

    case "$profile" in
        "lg")
            profile_lg "$name"
            ;;
        "xreal")
            profile_xreal "$name"
            ;;
        "default")
            profile_default "$name" "$width" "$height"
            ;;
    esac
done

current_edp=$(swaymsg -t get_outputs | jq -r '.[] | select(.name == "eDP-1") | .active')
if [ "$current_edp" != "true" ]; then
    external_active=$(swaymsg -t get_outputs | jq -r '[.[] | select(.name != "eDP-1" and .active)] | length')
    if [ "$external_active" -eq 0 ]; then
        swaymsg output eDP-1 enable
        swaymsg output eDP-1 pos 0 0 scale 1
    fi
fi
