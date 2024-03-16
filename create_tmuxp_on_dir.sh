#!/bin/zsh

WORKSPACE_DIR="$HOME/dev"
TMUXP_CONFIG_DIR="$HOME/dotfiles/tmuxp"

# Ensure tmuxp config directory exists
mkdir -p "$TMUXP_CONFIG_DIR"

# Watch for new directories in workspace
inotifywait -m -e create --format "%f" "$WORKSPACE_DIR" | while read DIRNAME
do
    # Check if a directory was created
    if [[ -d "$WORKSPACE_DIR/$DIRNAME" ]]; then
        # Create the tmuxp config file
        CONFIG_PATH="$TMUXP_CONFIG_DIR/$DIRNAME.yml"
        echo "session_name: $DIRNAME" > "$CONFIG_PATH"
        echo "start_directory: \$HOME/dev/$DIRNAME" >> "$CONFIG_PATH"
        echo "" >> "$CONFIG_PATH"
        echo "windows:" >> "$CONFIG_PATH"
        echo "  - window_name: $DIRNAME" >> "$CONFIG_PATH"
        echo "    layout: tiled" >> "$CONFIG_PATH"
        echo "    panes:" >> "$CONFIG_PATH"
        echo "      -" >> "$CONFIG_PATH"
        echo "tmuxp config for $DIRNAME created at $CONFIG_PATH"
    fi
done
