import os
import sys
import argparse
from typing import List, Set

def should_ignore(name: str, ignore_files: Set[str], ignore_folders: Set[str]) -> bool:
    return (name in ignore_files) or (name in ignore_folders)

def get_language_comment(file_extension: str) -> str:
    comment_styles = {
        '.py': '#', '.js': '//', '.java': '//', '.c': '//', '.cpp': '//',
        '.rb': '#', '.pl': '#', '.php': '//', '.swift': '//', '.go': '//',
        '.rs': '//', '.ts': '//', '.md': '', '.txt': '',
    }
    return comment_styles.get(file_extension.lower(), '#')

def write_file_header(outfile, relative_path: str, file_extension: str):
    comment_char = get_language_comment(file_extension)
    if file_extension in ['.md', '.txt']:
        outfile.write(f"\n\n{'=' * 80}\n")
        outfile.write(f"File: {relative_path}\n")
        outfile.write(f"{'=' * 80}\n\n")
    else:
        outfile.write(f"\n\n{comment_char} {'=' * 78}\n")
        outfile.write(f"{comment_char} File: {relative_path}\n")
        outfile.write(f"{comment_char} {'=' * 78}\n\n")

def process_file(file_path: str, outfile, base_path: str, file_extensions: Set[str]):
    file_extension = os.path.splitext(file_path)[1]
    if file_extension in file_extensions:
        relative_path = os.path.relpath(file_path, base_path)
        write_file_header(outfile, relative_path, file_extension)
        with open(file_path, 'r', encoding='utf-8') as infile:
            outfile.write(infile.read())
        outfile.write('\n')

def process_directory(dir_path: str, outfile, base_path: str, ignore_files: Set[str], ignore_folders: Set[str], file_extensions: Set[str]):
    for root, dirs, files in os.walk(dir_path):
        dirs[:] = [d for d in dirs if not should_ignore(d, ignore_files, ignore_folders)]
        for filename in files:
            if not should_ignore(filename, ignore_files, ignore_folders):
                file_path = os.path.join(root, filename)
                process_file(file_path, outfile, base_path, file_extensions)

def combine_sources(sources: List[str], output_file: str, ignore_files: Set[str], ignore_folders: Set[str], file_extensions: Set[str]):
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for source in sources:
            if os.path.isfile(source):
                process_file(source, outfile, os.path.dirname(source), file_extensions)
            elif os.path.isdir(source):
                process_directory(source, outfile, source, ignore_files, ignore_folders, file_extensions)
            else:
                print(f"警告: '{source}' は存在しないか、アクセスできません。スキップします。")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='複数のソース（ファイルとフォルダ）からファイルを結合します。')
    parser.add_argument('sources', nargs='+', help='結合するファイルやフォルダのパス')
    parser.add_argument('output_file', help='出力ファイルの名前')
    parser.add_argument('--ignore-files', nargs='*', default=[], help='無視するファイルのリスト')
    parser.add_argument('--ignore-folders', nargs='*', default=['venv', '__pycache__', 'node_modules'], help='無視するフォルダのリスト')
    parser.add_argument('--extensions', nargs='*', 
                        default=['.py', '.js', '.java', '.c', '.cpp', '.rb', '.pl', '.php', '.swift', '.go', '.rs', '.ts', '.md', '.txt'], 
                        help='処理するファイル拡張子のリスト')
    
    args = parser.parse_args()
    
    combine_sources(args.sources, args.output_file, set(args.ignore_files), set(args.ignore_folders), set(args.extensions))
    print(f"完了: 指定された条件に基づいてファイルが {args.output_file} にまとめられました。")