#!/bin/bash

# Define the preset
PRESET="Social 25 MB 1 Minute 720p60"

# Find all .mov files and process them
files=$(find . -type f -name "*.mov")

if [[ -z "$files" ]]; then
    echo "No .mov files found."
    exit 1
fi

for file in $files; do
    # Handle spaces in filenames properly
    file=$(realpath "$file")

    # Get directory and filename without extension
    dir=$(dirname "$file")
    filename=$(basename "$file" .mov)
    
    # Define the output filename
    output_file="$dir/$filename.mp4"
    
    # Convert using HandBrakeCLI and suppress unnecessary output
    echo "Processing: $file -> $output_file"
    ./HandBrakeCLI -i "$file" -o "$output_file" --preset "$PRESET" >/dev/null 2>&1
    
    # Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "✅ Successfully converted: $output_file"
        rm -f "$file"
    else
        echo "❌ Failed to convert: $file"
    fi
done

echo "Batch conversion complete."
