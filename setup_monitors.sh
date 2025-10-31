#!/usr/bin/env bash

echo "Running setup_monitors.sh at $(date)"

# Source monitor profiles
source "$HOME/dotfiles/sway/profiles/monitors.conf"

# Get all outputs information
outputs_json=$(swaymsg -t get_outputs)

# Check if any external monitors are connected
external_count=$(echo "$outputs_json" | jq -r '[.[] | select(.name != "eDP-1" and .active)] | length')

if [ "$external_count" -eq 0 ]; then
    profile_internal_only
    exit 0
fi

# Process each active external monitor
echo "$outputs_json" | jq -r '.[] | select(.active and .name != "eDP-1") | @json' | while read -r output; do
    name=$(echo "$output" | jq -r '.name')
    serial=$(echo "$output" | jq -r '.serial')
    model=$(echo "$output" | jq -r '.model')
    width=$(echo "$output" | jq -r '.current_mode.width')
    height=$(echo "$output" | jq -r '.current_mode.height')
    
    # Detect which profile to use
    profile=$(detect_profile "$serial" "$model")
    
    echo "Monitor detected: $name ($model, serial: $serial)"
    echo "Resolution: ${width}x${height}"
    echo "Profile: $profile"
    
    # Apply the appropriate profile
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