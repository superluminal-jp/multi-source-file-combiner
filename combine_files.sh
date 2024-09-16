#!/bin/bash

set -euo pipefail

# combine_files.sh
# This script combines multiple files into a single output file, including folder structure.
# It can process individual files and recursively process directories.
# Hidden files and directories (starting with '.') are ignored, except for the current directory.

# Function to print usage information
print_usage() {
    cat << EOF
Usage: $0 [-o output_file] [-i ignore_pattern] [-e file_extensions] [source1 [source2 ...]]
  -o output_file    : Specify the output file (default: combined_output.txt)
  -i ignore_pattern : Specify additional files/folders to ignore (glob pattern, can be used multiple times)
  -e file_extensions: Specify file extensions to include (comma-separated, default: all)
  source1 [source2 ...]: Source files or directories to combine (default: current directory)
Note: Hidden files and directories (starting with '.') are ignored, except for the current directory.
EOF
}

# Initialize variables
output_file="combined_output.txt"
ignore_patterns=()
file_extensions=()

# Parse command line options
while getopts "o:i:e:h" opt; do
    case $opt in
        o) output_file="$OPTARG" ;;
        i) ignore_patterns+=("$OPTARG") ;;
        e) IFS=',' read -ra file_extensions <<< "$OPTARG" ;;
        h) print_usage; exit 0 ;;
        *) print_usage >&2; exit 1 ;;
    esac
done

shift $((OPTIND-1))

# Function to check if a file or directory should be ignored
should_ignore() {
    local path="$1"
    local relative_path="$2"
    
    [[ "$path" == "." ]] && return 1
    [[ "$relative_path" == .* || "$relative_path" == */.* ]] && return 0
    
    if [[ ${#ignore_patterns[@]} -gt 0 ]]; then
        for pattern in "${ignore_patterns[@]}"; do
            [[ "$path" == $pattern ]] && return 0
        done
    fi
    
    if [[ ${#file_extensions[@]} -gt 0 && -f "$path" ]]; then
        local ext="${path##*.}"
        for valid_ext in "${file_extensions[@]}"; do
            [[ "$ext" == "$valid_ext" ]] && return 1
        done
        return 0
    fi
    
    return 1
}

# Function to check if a directory contains target files
contains_target_files() {
    local dir="$1"
    local base_path="$2"

    while IFS= read -r -d '' file; do
        local relative_path="${file#$base_path/}"
        if ! should_ignore "$file" "$relative_path"; then
            return 0
        fi
    done < <(find "$dir" -type f -print0 2>/dev/null)

    return 1
}

# Function to write folder structure in tree-like format
write_folder_structure() {
    local base_path="$1" current_path="$2" prefix="$3" is_last="$4"
    
    local dir_name="${current_path#$base_path/}"
    local new_prefix="$prefix"
    local has_content=false

    local items=()
    while IFS= read -r -d '' item; do
        items+=("$item")
    done < <(find "$current_path" -maxdepth 1 -mindepth 1 -print0 2>/dev/null | sort -z)

    local num_items=${#items[@]}
    local i=0
    local valid_items=()

    for item in "${items[@]}"; do
        local relative_path="${item#$base_path/}"
        if ! should_ignore "$item" "$relative_path"; then
            if [[ -d "$item" ]]; then
                if contains_target_files "$item" "$base_path"; then
                    valid_items+=("$item")
                    has_content=true
                fi
            elif [[ -f "$item" ]]; then
                valid_items+=("$item")
                has_content=true
            fi
        fi
    done

    if ! $has_content; then
        return 1
    fi

    if [[ -n "$dir_name" ]]; then
        if $is_last; then
            echo "${prefix}└── ${dir_name}/" >> "$output_file"
            new_prefix="${prefix}    "
        else
            echo "${prefix}├── ${dir_name}/" >> "$output_file"
            new_prefix="${prefix}│   "
        fi
    fi

    num_items=${#valid_items[@]}
    i=0

    for item in "${valid_items[@]}"; do
        ((i++))
        local is_last_item=$([[ $i -eq $num_items ]] && echo true || echo false)
        local relative_path="${item#$base_path/}"

        if [[ -d "$item" ]]; then
            write_folder_structure "$base_path" "$item" "$new_prefix" "$is_last_item"
        elif [[ -f "$item" ]]; then
            if $is_last_item; then
                echo "${new_prefix}└── $(basename "$item")" >> "$output_file"
            else
                echo "${new_prefix}├── $(basename "$item")" >> "$output_file"
            fi
        fi
    done

    return 0
}

# Function to write file header and content to the output file
write_file_content() {
    local file="$1"
    {
        echo -e "\n\n================================================================================"
        echo "File: $file"
        echo -e "================================================================================\n"
        cat "$file"
    } >> "$output_file"
}

# Function to process a file
process_file() {
    local file="$1" base_path="$2" source="$3"
    
    local relative_path="${file#$base_path/}"
    
    should_ignore "$file" "$relative_path" && return
    
    local display_path
    if [[ "$base_path" == "." ]]; then
        display_path="$file"
    else
        display_path="$source/$relative_path"
    fi
    echo "Processing file: $display_path"
    write_file_content "$file"
}

# Function to process a directory
process_directory() {
    local dir="$1" base_path="$2" source="$3"
    
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -type f -print0 2>/dev/null | sort -z)

    if [[ ${#files[@]} -eq 0 ]]; then
        return
    fi

    for file in "${files[@]}"; do
        process_file "$file" "$base_path" "$source"
    done
}

# Main processing function
main() {
    > "$output_file"  # Clear or create the output file

    local sources=("${@:-.}")  # Use current directory if no sources provided

    # Write folder structure
    {
        echo "Folder Structure:"
        echo "================="
        local has_content=false
        for source in "${sources[@]}"; do
            if [[ -d "$source" ]] && ! should_ignore "$source" "$source"; then
                if write_folder_structure "$source" "$source" "" true; then
                    has_content=true
                fi
            elif [[ -f "$source" ]] && ! should_ignore "$source" "$(basename "$source")"; then
                echo "$(basename "$source")"
                has_content=true
            fi
        done
        if ! $has_content; then
            echo "No matching files found."
        fi
        echo
    } >> "$output_file"

    # Process each source
    for source in "${sources[@]}"; do
        if [[ -f "$source" ]]; then
            process_file "$source" "." "$(basename "$source")"
        elif [[ -d "$source" ]]; then
            should_ignore "$source" "$source" || process_directory "$source" "$source" "$(basename "$source")"
        else
            echo "Warning: '$source' does not exist or is not accessible. Skipping." >&2
        fi
    done

    echo "Files have been combined into $output_file"
}

main "$@"
