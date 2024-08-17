#!/bin/bash

# Output file
output_file="combined_output.txt"

# Clear the output file if it already exists
> "$output_file"

# Function to append file content with header
append_file () {
    echo "---- START OF $1 ----" >> "$output_file"
    cat "$1" >> "$output_file"
    echo -e "\n---- END OF $1 ----\n\n" >> "$output_file"
}

# Append each file
append_file ".gitlab-ci.yml"
append_file "docker-compose.ci.yml"
append_file "docker-compose.prod.yml"
append_file "docker-compose.yml"
append_file "PintAndPillageFrontend/Dockerfile"
append_file "PintAndPillageJavaBackend/Dockerfile"
append_file "nginx/default.conf"
append_file ".env"
append_file "PintAndPillageFrontend/vue.config.js"

echo "Files combined into $output_file"
