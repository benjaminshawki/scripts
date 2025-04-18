# Sway Emoji Picker Configuration

## Add these lines to your Sway config file

```
# Emoji picker with FZF (copies to clipboard)
bindsym $mod+period exec $USER_BIN/emoji-picker/emoji-picker.sh

# Set floating window properties for the emoji picker
for_window [app_id="^emoji-picker$"] floating enable, border none, resize set width 65 ppt height 60 ppt, move position center
```

## Update your existing launcher script

Modify your existing `fzf-launcher-close-when-unfocussed.sh` to include the emoji picker:

```bash
#!/usr/bin/env bash

# Listen for window focus events
swaymsg -t subscribe -m '[ "window" ]' | jq --unbuffered '
  select(.change == "focus") | .container.app_id' |
while read app_id; do
  # If the new focus is not on the launcher or emoji-picker, close them
  if [[ $app_id != "\"launcher\"" && $app_id != "\"emoji-picker\"" ]]; then
    swaymsg '[app_id="^launcher$|^emoji-picker$"]' kill
  fi
done
```

## Usage
1. Press $mod+period to open the emoji picker
2. Type to search for emojis
3. Use arrow keys to navigate
4. Press Enter to select an emoji (it will be copied to your clipboard)
5. Paste the emoji where you want using Ctrl+V or your paste shortcut