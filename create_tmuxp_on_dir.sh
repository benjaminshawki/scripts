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
        # Create the tmuxp config file using a here-document for simplicity
        CONFIG_PATH="$TMUXP_CONFIG_DIR/$DIRNAME.yml"
        cat > "$CONFIG_PATH" <<EOF
session_name: $DIRNAME
start_directory: \$HOME/dev/$DIRNAME

windows:
  - window_name: $DIRNAME
    layout: tiled
    panes:
      -
  - window_name: terms
    layout: tiled
    panes:
      -
EOF
        echo "tmuxp config for $DIRNAME created at $CONFIG_PATH"
    fi
done
