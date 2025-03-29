## 2024-07-27

- Refactored `FileService.exportToJson` to use the `file_saver` package instead of manual file path handling and writing. This simplifies the code and uses the platform's standard save dialog. 