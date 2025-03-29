## 2024-07-27

- Refactored `FileService.exportToJson` to use the `file_saver` package instead of manual file path handling and writing. This simplifies the code and uses the platform's standard save dialog.
- Fixed exported file having `.json.txt` extension by setting the correct `application/json` MIME type when using `file_saver`. 