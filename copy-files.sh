# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Get the file name and extension
#     file_name=$(basename "$file")
#     file_ext="${file##*.}"
#
#     # Read the content of the file
#     file_content=$(cat "$file")
#
#     # Append formatted content to clipboard_content
#     clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | wl-copy
#
# echo "Formatted content copied to clipboard!"


# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file
#         file_content=$(cat "$file")
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | wl-copy
#
# echo "Formatted content copied to clipboard!"

# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file and replace null bytes with a placeholder or remove them
#         file_content=$(cat "$file" | tr <(echo -ne '\0') ' ')
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# if [[ "$(wl-paste)" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
# fi

# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file and replace null bytes with a placeholder or remove them
#         file_content=$(cat "$file" | tr <(echo -ne '\0') ' ')
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# if [[ "$(wl-paste)" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
# fi

# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file and remove null bytes
#         file_content=$(tr -d '\000' < "$file")
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# if [[ "$(wl-paste)" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
# fi

# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file, removing null bytes
#         file_content=$(tr -d '\000' < "$file")
#
#         # Check if there are still any null bytes after processing (for logging purposes)
#         if echo "$file_content" | grep -q '\000'; then
#             echo "Warning: Null byte detected in $file after processing"
#         fi
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy
# echo -e "$clipboard_content" | tr -d '\000' | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# if [[ "$(wl-paste)" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
# fi

# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file, removing null bytes
#         file_content=$(tr -d '\000' < "$file")
#
#         # Check if there are still any null bytes after processing (using grep -P to handle binary data)
#         if echo "$file_content" | grep -qP '\x00'; then
#             echo "Warning: Null byte detected in $file after processing"
#         fi
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Copy the content to the clipboard using wl-copy, removing any leftover null bytes
# echo -e "$clipboard_content" | tr -d '\000' | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# if [[ "$(wl-paste)" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
# fi
#
# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
# total_size=0
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file, removing null bytes
#         file_content=$(tr -d '\000' < "$file")
#
#         # Check if there are still any null bytes after processing (using grep -P to handle binary data)
#         if echo "$file_content" | grep -qP '\x00'; then
#             echo "Warning: Null byte detected in $file after processing"
#         fi
#
#         # Calculate the size of the current content
#         current_size=$(echo -n "$file_content" | wc -c)
#         total_size=$((total_size + current_size))
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#     fi
# done
#
# # Log total size for debugging
# echo "Total content size: $total_size bytes"
#
# # Truncate content if it exceeds 100,000 bytes (arbitrary limit for testing)
# max_clipboard_size=100000
# if [ "$total_size" -gt "$max_clipboard_size" ]; then
#     echo "Content size exceeds $max_clipboard_size bytes, truncating for clipboard..."
#     clipboard_content="${clipboard_content:0:$max_clipboard_size}"
# fi
#
# # Copy the content to the clipboard using wl-copy, removing any leftover null bytes
# echo -e "$clipboard_content" | tr -d '\000' | wl-copy
#
# # Validate clipboard copy by checking if clipboard_content matches clipboard data
# copied_content=$(wl-paste)
# if [[ "$copied_content" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard!"
# else
#     echo "Failed to copy content to clipboard!"
#     echo "Copied content size: $(echo -n "$copied_content" | wc -c) bytes"
# fi
# #!/bin/bash
#
# # Initialize an empty string to hold the clipboard content
# clipboard_content=""
# total_size=0
#
# for file in "$@"; do
#     # Check if the argument is a file and not a directory
#     if [ -f "$file" ]; then
#         # Get the file name and extension
#         file_name=$(basename "$file")
#         file_ext="${file##*.}"
#
#         # Read the content of the file, removing null bytes
#         file_content=$(tr -d '\000' < "$file")
#
#         # Append formatted content to clipboard_content
#         clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
#         
#         # Calculate the size of the current content
#         current_size=$(echo -n "$file_content" | wc -c)
#         total_size=$((total_size + current_size))
#     fi
# done
#
# # Log total size for debugging
# echo "Total content size: $total_size bytes"
#
# # Copy the content to the clipboard using wl-copy, removing any leftover null bytes
# echo -e "$clipboard_content" | tr -d '\000' | wl-copy
#
# # Retrieve the content back from the clipboard
# copied_content=$(wl-paste)
#
# # Validate clipboard copy by checking for differences character by character
# if [[ "$copied_content" == "$clipboard_content" ]]; then
#     echo "Formatted content copied to clipboard successfully!"
# else
#     echo "Failed to copy content to clipboard!"
#
#     # Print sizes of original and copied content
#     original_size=$(echo -n "$clipboard_content" | wc -c)
#     copied_size=$(echo -n "$copied_content" | wc -c)
#     echo "Original size: $original_size bytes"
#     echo "Copied size: $copied_size bytes"
#
#     # Show the differences between the original and copied content
#     echo "Comparing contents for differences..."
#     diff <(echo -n "$clipboard_content") <(echo -n "$copied_content") | head -n 20
# fi
#

#!/bin/bash

# Initialize an empty string to hold the clipboard content
clipboard_content=""
total_size=0

for file in "$@"; do
    # Check if the argument is a file and not a directory
    if [ -f "$file" ]; then
        # Get the file name and extension
        file_name=$(basename "$file")
        file_ext="${file##*.}"

        # Read the content of the file, removing null bytes
        file_content=$(tr -d '\000' < "$file")

        # Append formatted content to clipboard_content using printf to avoid extra newlines
        clipboard_content+="$file_name\n\`\`\`$file_ext\n$file_content\n\`\`\`\n\n"
        
        # Calculate the size of the current content
        current_size=$(echo -n "$file_content" | wc -c)
        total_size=$((total_size + current_size))
    fi
done

# Log total size for debugging
echo "Total content size: $total_size bytes"

# Copy the content to the clipboard using printf instead of echo
printf "%s" "$clipboard_content" | tr -d '\000' | wl-copy

# Retrieve the content back from the clipboard
copied_content=$(wl-paste)

# Validate clipboard copy by checking for differences character by character
if [[ "$copied_content" == "$clipboard_content" ]]; then
    echo "Formatted content copied to clipboard successfully!"
else
    echo "Failed to copy content to clipboard!"

    # Print sizes of original and copied content
    original_size=$(echo -n "$clipboard_content" | wc -c)
    copied_size=$(echo -n "$copied_content" | wc -c)
    echo "Original size: $original_size bytes"
    echo "Copied size: $copied_size bytes"

    # Show the differences between the original and copied content
    echo "Comparing contents for differences..."
    diff <(echo -n "$clipboard_content") <(echo -n "$copied_content") | head -n 20
fi

