#!/bin/bash

# Function to print usage information
print_usage() {
    echo "Usage: $0 [-o output_file] [-i ignore_pattern] [-e file_extensions] source1 [source2 ...]"
    echo "  -o output_file    : Specify the output file (default: combined_output.txt)"
    echo "  -i ignore_pattern : Specify files/folders to ignore (glob pattern, can be used multiple times)"
    echo "  -e file_extensions: Specify file extensions to include (comma-separated, default: all)"
    echo "  source1 [source2 ...]: Source files or directories to combine"
}

# Initialize variables
output_file="combined_output.txt"
ignore_patterns=()
file_extensions=""

# Parse command line options
while getopts "o:i:e:h" opt; do
    case $opt in
        o) output_file="$OPTARG" ;;
        i) ignore_patterns+=("$OPTARG") ;;
        e) file_extensions="$OPTARG" ;;
        h) print_usage; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; print_usage; exit 1 ;;
    esac
done

# Shift the parsed options
shift $((OPTIND-1))

# Check if at least one source is provided
if [ $# -eq 0 ]; then
    echo "Error: At least one source must be specified." >&2
    print_usage
    exit 1
fi

# Function to write file header
write_file_header() {
    local file="$1"
    echo -e "\n\n================================================================================" >> "$output_file"
    echo "File: $file" >> "$output_file"
    echo -e "================================================================================\n" >> "$output_file"
}

# Function to process a file
process_file() {
    local file="$1"
    local base_path="$2"
    
    # Check if file should be ignored
    for pattern in "${ignore_patterns[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return
        fi
    done
    
    # Check file extension if specified
    if [ -n "$file_extensions" ]; then
        local ext="${file##*.}"
        if [[ ! "$file_extensions" == *"$ext"* ]]; then
            return
        fi
    fi
    
    # Write file header and content
    local relative_path="${file#$base_path/}"
    write_file_header "$relative_path"
    cat "$file" >> "$output_file"
}

# Function to process a directory
process_directory() {
    local dir="$1"
    local base_path="$2"
    
    find "$dir" -type f | while IFS= read -r file; do
        process_file "$file" "$base_path"
    done
}

# Main processing loop
> "$output_file"  # Clear or create the output file
for source in "$@"; do
    if [ -f "$source" ]; then
        process_file "$source" "$(dirname "$source")"
    elif [ -d "$source" ]; then
        process_directory "$source" "$source"
    else
        echo "Warning: '$source' does not exist or is not accessible. Skipping." >&2
    fi
done

echo "Files have been combined into $output_file"
