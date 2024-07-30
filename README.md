# Multi-Source File Combiner

A flexible utility that combines multiple files and folders into a single output file, supporting various file types and customizable filtering options. This project provides both Python and Bash implementations for maximum flexibility.

## Overview

The Multi-Source File Combiner is a powerful and versatile tool designed to streamline the process of combining multiple files and folders into a single, well-organized output file. This utility is particularly useful for developers, technical writers, and anyone working with multiple files across various projects.

### Key Features:

- Multiple implementations: Choose between Python and Bash versions
- Supports multiple input sources: Combine files from various locations and folders
- Language-agnostic: Works with multiple programming languages and text formats
- Customizable: Easily ignore specific files or folders and filter by file extensions
- Intelligent output: Generates a neatly formatted output with clear file separators
- User-friendly: Simple command-line interface with intuitive options

Whether you're consolidating code for review, preparing documentation, or simply organizing your project files, the Multi-Source File Combiner offers an efficient and adaptable solution to meet your needs.

## Requirements

- For Python version: Python 3.x
- For Bash version: Bash shell (available on most Unix-like operating systems, including Linux and macOS)

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/multi-source-file-combiner.git
   ```
2. Navigate to the project directory:
   ```
   cd multi-source-file-combiner
   ```
3. For the Bash version, make the script executable:
   ```
   chmod +x combine_files.sh
   ```

No additional dependencies are required.

## Usage

### Python Version

#### Basic Command

```
python combine_files.py <source1> [source2 ...] <output_file> [options]
```

#### Options

- `--ignore-files [FILES ...]`: List of files to ignore
- `--ignore-folders [FOLDERS ...]`: List of folders to ignore
- `--extensions [EXTENSIONS ...]`: List of file extensions to process

#### Example

```
python combine_files.py /path/to/src /path/to/docs /path/to/main.py combined_output.txt --ignore-files README.md --ignore-folders tests --extensions .py .js .md .txt
```

### Bash Version

#### Basic Command

```
./combine_files.sh [-o output_file] [-i ignore_pattern] [-e file_extensions] source1 [source2 ...]
```

#### Options

- `-o output_file`: Specify the output file (default: combined_output.txt)
- `-i ignore_pattern`: Specify files/folders to ignore (glob pattern, can be used multiple times)
- `-e file_extensions`: Specify file extensions to include (comma-separated, default: all)

#### Example

```
./combine_files.sh -o combined.txt -i "*.log" -i "temp*" -e py,js,md /path/to/src /path/to/docs /path/to/main.py
```

## Output Format

Both versions of the script combine files with clear separation:

```
================================================================================
File: src/main.js
================================================================================

[Content of main.js]

================================================================================
File: src/utils.py
================================================================================

[Content of utils.py]

================================================================================
File: docs/README.md
================================================================================

[Content of README.md]
```

## Customization

### Python Version

You can easily extend the Python script to support additional file types:

1. Add new file extensions to the `comment_styles` dictionary in the `get_language_comment` function.
2. If necessary, modify the `write_file_header` function to handle any special cases for new file types.

### Bash Version

The Bash version uses a simpler header format for all file types. To customize:

1. Modify the `write_file_header` function in the script to change the header format.
2. Adjust the file extension filtering in the main processing loop if needed.

## Limitations

- Both scripts assume UTF-8 encoding for all files. Files with different encodings may not be processed correctly.
- Very large files or a large number of files may impact performance.
- The Bash version may have limited functionality on non-Unix-like systems.

## Troubleshooting

- If you encounter "Permission denied" errors, ensure you have read access to all files and folders.
- For "File not found" errors, check that the specified file or folder paths are correct.
- If a specified source doesn't exist or is inaccessible, both scripts will display a warning and skip that source.

## Contributing

Contributions to the Multi-Source File Combiner are welcome! Here's how you can contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

Please ensure your code adheres to the existing style to maintain consistency.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Your Name - [@your_twitter](https://twitter.com/your_twitter) - email@example.com

Project Link: [https://github.com/yourusername/multi-source-file-combiner](https://github.com/yourusername/multi-source-file-combiner)
