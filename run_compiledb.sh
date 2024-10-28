#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <output_file> <project_dir>"
    exit 1
fi

# Assign parameters to variables
COMPILEDB_PATH=$1
OUTPUT_FILE=$2
PROJECT_DIR=$3

COMPILEDB_PATH=$HOME/.local/bin/compiledb

# Execute the compiledb command with the provided parameters
$COMPILEDB_PATH -o $OUTPUT_FILE -- make -C $PROJECT_DIR -j16 all
