# Multi-Source File Combiner

A flexible Python script that combines multiple files and folders into a single output file, supporting various programming languages and text formats.

## Overview

The Multi-Source File Combiner is a powerful and flexible Python utility designed to streamline the process of combining multiple files and folders into a single, well-organized output file. This tool is particularly useful for developers, technical writers, and anyone working with multiple code or text files across various projects.

### Key Features:

- Supports multiple input sources: Combine files from various locations and folders
- Language-agnostic: Works with multiple programming languages and text formats
- Customizable: Easily ignore specific files or folders and filter by file extensions
- Intelligent output: Generates a neatly formatted output with clear file separators
- User-friendly: Simple command-line interface with intuitive options

Whether you're consolidating code for review, preparing documentation, or simply organizing your project files, the Multi-Source File Combiner offers an efficient and adaptable solution to meet your needs.

## Requirements

- Python 3.x

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/multi-source-file-combiner.git
   ```
2. Navigate to the project directory:
   ```
   cd multi-source-file-combiner
   ```

No additional dependencies are required.

## Usage

### Basic Command

```
python combine_files.py <source1> [source2 ...] <output_file> [options]
```

### Command-line Arguments

- `<source1> [source2 ...]`: Paths to files and/or folders to be combined (at least one required)
- `<output_file>`: Name of the output file where combined content will be saved (required)

### Options

- `--ignore-files [FILES ...]`: List of files to ignore
- `--ignore-folders [FOLDERS ...]`: List of folders to ignore
- `--extensions [EXTENSIONS ...]`: List of file extensions to process

### Default Values

- Ignored folders: `venv`, `__pycache__`, `node_modules`
- Processed extensions: `.py`, `.js`, `.java`, `.c`, `.cpp`, `.rb`, `.pl`, `.php`, `.swift`, `.go`, `.rs`, `.ts`, `.md`, `.txt`

### Examples

1. Basic usage with multiple sources:
   ```
   python combine_files.py /path/to/folder1 /path/to/file1.py /path/to/folder2 combined_output.txt
   ```

2. Specify files and folders to ignore:
   ```
   python combine_files.py /path/to/project combined_output.txt --ignore-files README.md temp.txt --ignore-folders docs temp
   ```

3. Process only specific file types:
   ```
   python combine_files.py /path/to/src /path/to/docs combined_output.txt --extensions .py .js .md
   ```

4. Combine all options:
   ```
   python combine_files.py /path/to/src /path/to/docs /path/to/main.py combined_output.txt --ignore-files README.md --ignore-folders tests --extensions .py .js .md .txt
   ```

## Output Format

The script combines files with clear separation:

- For code files, it uses language-specific comment characters to create headers.
- For Markdown and text files, it uses ASCII art separators.

Example output structure:

```
// ============================================================================
// File: src/main.js
// ============================================================================

[Content of main.js]

# ============================================================================
# File: src/utils.py
# ============================================================================

[Content of utils.py]

================================================================================
File: docs/README.md
================================================================================

[Content of README.md]
```

## Customization

You can easily extend the script to support additional file types:

1. Add new file extensions to the `comment_styles` dictionary in the `get_language_comment` function.
2. If necessary, modify the `write_file_header` function to handle any special cases for new file types.

## Limitations

- The script assumes UTF-8 encoding for all files. Files with different encodings may not be processed correctly.
- Very large files or a large number of files may impact performance.

## Troubleshooting

- If you encounter "Permission denied" errors, ensure you have read access to all files and folders.
- For "File not found" errors, check that the specified file or folder paths are correct.
- If a specified source doesn't exist or is inaccessible, the script will display a warning and skip that source.

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
