#!/bin/bash

# Initialize an empty string to hold the clipboard content
clipboard_content=""

for file in "$@"; do
    # Get the file name and extension
    file_name=$(basename "$file")
    file_ext="${file##*.}"

    # Read the content of the file
    file_content=$(cat "$file")

    # Append formatted content to clipboard_content
    clipboard_content+="$file_name\n\`\`\`.$file_ext\n$file_content\n\`\`\`\n\n"
done

# Copy the content to the clipboard using wl-copy
echo -e "$clipboard_content" | wl-copy

echo "Formatted content copied to clipboard!"
