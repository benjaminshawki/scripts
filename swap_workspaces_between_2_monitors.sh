#!/usr/bin/env bash

# 1) Get a list of all active outputs
outputs=( $(swaymsg -t get_outputs -r | jq -r '.[] | select(.active).name') )

# 2) Prompt you to pick two with fzf (multi-select)
selected=($(printf '%s\n' "${outputs[@]}" | \
    fzf --prompt="Pick two outputs to swap> " --multi --height 50% --border --ansi))

# We only proceed if exactly two outputs are chosen
if [ "${#selected[@]}" -ne 2 ]; then
  echo "You must pick exactly two outputs."
  exit 1
fi

out1="${selected[0]}"
out2="${selected[1]}"

echo "Swapping workspaces between $out1 and $out2"

# 3) Find the workspace names for each output
ws_out1=( $(swaymsg -t get_workspaces -r | jq -r ".[] | select(.output == \"$out1\").name") )
ws_out2=( $(swaymsg -t get_workspaces -r | jq -r ".[] | select(.output == \"$out2\").name") )

echo "Workspaces on $out1: ${ws_out1[@]}"
echo "Workspaces on $out2: ${ws_out2[@]}"

for w in "${ws_out1[@]}"; do
	echo "Moving $w to $out2"
	swaymsg "[workspace=\"$w\"] move workspace to output \"$out2\""
done

for w in "${ws_out2[@]}"; do
	echo "Moving $w to $out1"
	swaymsg "[workspace=\"$w\"] move workspace to output \"$out1\""
done
