#!/bin/bash

# Reading list manager with fzf interface
# Simple flat list format: "Name :: URL/Path"

NOTES_DIR="${NOTES:-$HOME/Notes}"
READING_LIST_DIR="$NOTES_DIR/reading_list"
READING_LIST_FILE="$READING_LIST_DIR/reading_list.json"

# Ensure directories exist
mkdir -p "$READING_LIST_DIR"

# Initialize JSON file if it doesn't exist
if [ ! -f "$READING_LIST_FILE" ]; then
    echo "[]" > "$READING_LIST_FILE"
fi

# Function to open URL/file based on type
open_item() {
    local item="$1"
    echo "DEBUG: Opening item: '$item'" >&2
    if [ -n "$item" ]; then
        # Check if it's a URL
        if [[ "$item" =~ ^https?:// ]]; then
            echo "DEBUG: Opening URL in browser" >&2
            nohup $BROWSER --new-window "$item" >/dev/null 2>&1 &
        # Check if it's a PDF or EPUB file
        elif [[ "$item" =~ \.(pdf|epub)$ ]] && [ -f "$item" ]; then
            echo "DEBUG: Opening PDF/EPUB in zathura" >&2
            echo "DEBUG: Full path: '$item'" >&2
            zathura "$item" &
            disown
        # Check if it's a markdown file
        elif [[ "$item" =~ \.md$ ]] && [ -f "$item" ]; then
            echo "DEBUG: Opening markdown in nvim" >&2
            foot -e nvim "$item" &
            disown
        # Check if it's any other existing file
        elif [ -f "$item" ]; then
            echo "DEBUG: Opening file in nvim" >&2
            foot -e nvim "$item" &
            disown
        else
            echo "DEBUG: Unknown item type or file not found: $item" >&2
            echo "DEBUG: File exists check: $([ -f "$item" ] && echo 'yes' || echo 'no')" >&2
            sleep 2
            exit 1
        fi
        sleep 0.5
        exit 0
    fi
}

# Function to open an entry
open_entry() {
    local entry="$1"
    # Extract the URL/path after the :: delimiter
    local path=$(echo "$entry" | sed 's/^.*:: //')
    open_item "$path"
}

# Function to add a new entry
add_entry() {
    echo "Adding new entry..."
    echo
    read -p "Name: " name
    if [ -z "$name" ]; then
        echo "Name cannot be empty"
        return 1
    fi
    
    read -p "URL/Path: " path
    if [ -z "$path" ]; then
        echo "Path cannot be empty"
        return 1
    fi
    
    # Expand tilde in paths
    path="${path/#\~/$HOME}"
    
    # Create the entry
    local entry="$name :: $path"
    
    # Add to JSON array
    local temp_file=$(mktemp)
    jq --arg new "$entry" '. += [$new]' "$READING_LIST_FILE" > "$temp_file" && mv "$temp_file" "$READING_LIST_FILE"
    
    echo "Entry added successfully!"
}

# Function to edit an existing entry
edit_entry() {
    local old_entry="$1"
    local old_name=$(echo "$old_entry" | sed 's/ :: .*//')
    local old_path=$(echo "$old_entry" | sed 's/^.*:: //')
    
    echo "Editing entry:"
    echo "Current: $old_entry"
    echo
    
    read -p "New name (Enter to keep: $old_name): " new_name
    if [ -z "$new_name" ]; then
        new_name="$old_name"
    fi
    
    read -p "New URL/Path (Enter to keep: $old_path): " new_path
    if [ -z "$new_path" ]; then
        new_path="$old_path"
    else
        # Expand tilde in paths
        new_path="${new_path/#\~/$HOME}"
    fi
    
    # Create the new entry
    local new_entry="$new_name :: $new_path"
    
    # Replace in JSON array
    local temp_file=$(mktemp)
    jq --arg old "$old_entry" --arg new "$new_entry" 'map(if . == $old then $new else . end)' "$READING_LIST_FILE" > "$temp_file" && mv "$temp_file" "$READING_LIST_FILE"
    
    echo "Entry updated successfully!"
}

# Function to delete an entry
delete_entry() {
    local entry="$1"
    
    echo "Are you sure you want to delete:"
    echo "$entry"
    read -p "Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        local temp_file=$(mktemp)
        jq --arg del "$entry" 'map(select(. != $del))' "$READING_LIST_FILE" > "$temp_file" && mv "$temp_file" "$READING_LIST_FILE"
        echo "Entry deleted successfully!"
    else
        echo "Deletion cancelled"
    fi
}

# Main FZF interface
main_menu() {
    while true; do
        # Get all entries from JSON
        local entries=$(jq -r '.[]' "$READING_LIST_FILE" 2>/dev/null)
        
        # Add all PDFs and EPUBs from Books directory
        local books=""
        if [ -d "$NOTES_DIR/Books" ]; then
            # Find all PDF and EPUB files
            books=$(find "$NOTES_DIR/Books" -type f \( -name "*.pdf" -o -name "*.epub" \) 2>/dev/null | \
                    while read -r file; do
                        # Extract just the filename without path for the name
                        basename="${file##*/}"
                        # Remove extension for cleaner name
                        name="${basename%.*}"
                        echo "[Book] $name :: $file"
                    done)
        fi
        
        # Combine entries
        if [ -n "$books" ]; then
            if [ -n "$entries" ]; then
                entries="$entries"$'\n'"$books"
            else
                entries="$books"
            fi
        fi
        
        if [ -z "$entries" ]; then
            entries="(empty) :: No entries found. Press Ctrl+a to add a new entry."
        fi
        
        # Create temporary file for action
        local action_file=$(mktemp)
        
        # Main FZF menu
        local selected=$(echo "$entries" | fzf --reverse --border rounded \
            --prompt "Search reading items: " \
            --header $'╱ Ctrl+Enter: Open ╱ Ctrl+e: Edit ╱ Ctrl+a: Add ╱ Ctrl+d: Delete ╱ Esc/q: Quit ╱\n' \
            --info inline \
            --bind "ctrl-m:execute-silent(echo 'open:{}' > $action_file)+abort" \
            --bind "ctrl-e:execute-silent(echo 'edit:{}' > $action_file)+abort" \
            --bind "ctrl-a:execute-silent(echo 'add' > $action_file)+abort" \
            --bind "ctrl-d:execute-silent(echo 'delete:{}' > $action_file)+abort" \
            --bind 'q:abort' \
            --bind 'esc:abort')
        
        # Check if user quit (no action file content means abort)
        if [ ! -s "$action_file" ]; then
            rm -f "$action_file"
            break
        fi
        
        # Read the action
        local action=$(cat "$action_file")
        rm -f "$action_file"
        
        # Parse and execute the action
        if [[ "$action" == open:* ]]; then
            local entry=$(echo "$action" | sed 's/open://')
            if [ "$entry" != "(empty) :: No entries found. Press Ctrl+a to add a new entry." ]; then
                open_entry "$entry"
                break  # Exit after opening
            fi
        elif [[ "$action" == edit:* ]]; then
            local entry=$(echo "$action" | sed 's/edit://')
            if [[ ! "$entry" =~ ^\(empty\) ]]; then
                clear
                edit_entry "$entry"
                echo
                read -p "Press Enter to continue..."
            fi
        elif [[ "$action" == add* ]]; then
            clear
            add_entry
            echo
            read -p "Press Enter to continue..."
        elif [[ "$action" == delete:* ]]; then
            local entry=$(echo "$action" | sed 's/delete://')
            if [[ ! "$entry" =~ ^\(empty\) ]]; then
                clear
                delete_entry "$entry"
                echo
                read -p "Press Enter to continue..."
            fi
        fi
    done
}

# Handle command line arguments
case "$1" in
    --migrate)
        # Migrate old format to new format
        echo "Migrating reading list to new format..."
        if [ -f "$READING_LIST_FILE" ]; then
            # Check if it's already in array format
            if jq -e 'type == "array"' "$READING_LIST_FILE" >/dev/null 2>&1; then
                echo "Reading list is already in the new format."
            else
                # Convert from object to array format
                temp_file=$(mktemp)
                jq 'to_entries | map(.value.urls[] as $url | "\(.value.name) :: \($url)")' "$READING_LIST_FILE" > "$temp_file" && mv "$temp_file" "$READING_LIST_FILE"
                echo "Migration completed successfully!"
            fi
        fi
        ;;
    --add)
        # Command line add
        if [ $# -lt 3 ]; then
            echo "Usage: $0 --add <name> <url/path>"
            exit 1
        fi
        name="$2"
        shift 2
        path="$*"
        path="${path/#\~/$HOME}"
        entry="$name :: $path"
        temp_file=$(mktemp)
        jq --arg new "$entry" '. += [$new]' "$READING_LIST_FILE" > "$temp_file" && mv "$temp_file" "$READING_LIST_FILE"
        echo "Entry '$name' added"
        ;;
    --tmuxp)
        # tmuxp integration - open first matching entry
        if [ -z "$2" ]; then
            echo "Usage: $0 --tmuxp <search-term>"
            exit 1
        fi
        entry=$(jq -r '.[]' "$READING_LIST_FILE" 2>/dev/null | grep -i "$2" | head -n1)
        if [ -n "$entry" ]; then
            open_entry "$entry"
        else
            echo "No entry found matching: $2"
            exit 1
        fi
        ;;
    "")
        # Interactive mode
        main_menu
        ;;
    *)
        # Direct search and open
        entry=$(jq -r '.[]' "$READING_LIST_FILE" 2>/dev/null | grep -i "$1" | head -n1)
        if [ -n "$entry" ]; then
            open_entry "$entry"
        else
            echo "No entry found matching: $1"
            exit 1
        fi
        ;;
esac