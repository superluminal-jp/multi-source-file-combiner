# File Combiner Script Documentation

## Overview

`combine_files.py` is a Python script that combines multiple files of various types (including code, Markdown, and text files) from specified files and folders into a single output file. It offers flexibility in terms of input sources, file types to process, and allows for customization of ignored files and folders.

## Features

- Supports multiple input sources (files and folders)
- Handles various file types including multiple programming languages, Markdown, and plain text
- Recursive folder scanning
- Customizable file and folder exclusions
- Flexible file extension filtering
- Appropriate file separation and headers in the combined output

## Requirements

- Python 3.x

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

## Examples

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

Feel free to fork this script and adapt it to your needs. Contributions, bug reports, and feature requests are welcome.


# Prompt

```
# Pythonコード整理プロンプト

与えられたPythonコードを深く理解し、機能を損なうことなくベストプラクティスに従って整理するためのガイドラインです。

## 1. コード分析

- コード全体の構造と目的を詳細に分析してください。
- 各モジュール、クラス、関数の役割を特定し、相互の依存関係を理解してください。
- 使用されているライブラリやフレームワークを確認し、それらの最新のベストプラクティスを考慮してください。

## 2. 問題点の特定

- PEP 8スタイルガイドに違反している箇所を特定してください。
- 非効率的な部分、重複コード、過度に複雑な実装がないか確認してください。
- 潜在的なパフォーマンス問題やメモリリークがないか調査してください。

## 3. リファクタリングと最適化

以下のPythonベストプラクティスに基づいてコードを整理してください：

a) PEP 8スタイルガイドに準拠するようにコードをフォーマットする。
b) 適切な命名規則を使用し、変数名や関数名をより明確で説明的なものにする（例：スネークケースを使用）。
c) リスト内包表記、ジェネレータ式、`map()`、`filter()`などのPythonic な構文を適切に使用する。
d) 関数やクラスの責任を明確に分離し、単一責任の原則を適用する。
e) タイプヒントを追加し、コードの可読性と保守性を向上させる。
f) 適切なデータ構造（リスト、辞書、集合など）を使用してパフォーマンスを最適化する。
g) コンテキストマネージャ（`with`文）を使用してリソース管理を改善する。
h) 例外処理を適切に実装し、具体的な例外クラスを使用する。
i) 繰り返し使用されるコードをヘルパー関数やユーティリティクラスに抽出する。
j) 不要なグローバル変数を削除し、関数の引数として渡すようにする。

## 4. ドキュメンテーションの改善

- 各モジュール、クラス、関数にドックストリングを追加または更新する。
- 複雑なロジックには適切なインラインコメントを追加する。
- READMEファイルを作成または更新し、プロジェクトの概要、セットアップ手順、使用方法を記述する。

## 5. テストの拡充

- 単体テストを作成または更新し、リファクタリングによる機能の変更がないことを確認する。
- `pytest`や`unittest`などのテストフレームワークを使用する。
- エッジケースや境界値のテストケースを追加する。

## 6. パフォーマンス最適化

- プロファイリングツール（例：cProfile）を使用して、パフォーマンスのボトルネックを特定する。
- 必要に応じて、計算量の少ないアルゴリズムや効率的なデータ構造に置き換える。
- 大規模なデータセットを扱う場合は、ジェネレータや`itertools`モジュールの使用を検討する。

## 7. モジュール構成の最適化

- 関連する機能をモジュールやパッケージに適切に分割する。
- 循環インポートを避け、明確な依存関係構造を作成する。
- `__init__.py`ファイルを適切に使用し、パッケージのインターフェースを整理する。

## 8. 変更点の文書化

- リファクタリングの各ステップを説明し、変更の理由と期待される改善点を詳細に記述する。
- 変更履歴を管理するために、バージョン管理システム（Git等）のコミットメッセージを適切に記述する。

## 9. 最終チェック

- リファクタリング後のコードが元の機能を完全に保持していることを確認する。
- 全てのテストが通過することを確認する。
- コードの可読性、保守性、拡張性が向上していることを確認する。

このガイドラインに従うことで、Pythonコードを効果的に整理し、品質を向上させることができます。必要に応じて、特定のプロジェクトや要件に合わせてこのプロンプトをカスタマイズしてください。
```