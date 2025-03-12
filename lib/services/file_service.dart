import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileService {
  // Open file picker to select a file for import
  static Future<String?> pickFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions ?? ['json', 'csv'],
    );
    
    if (result != null && result.files.single.path != null) {
      return result.files.single.path;
    }
    return null;
  }
  
  // Share a file using the system's share dialog
  static Future<void> shareFile(File file) async {
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'My Todo List');
    } else {
      throw Exception('File does not exist');
    }
  }
  
  // Determine the file type from the file extension
  static String getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return extension;
  }
  
  // Get a temporary directory for storing files
  static Future<Directory> getTemporaryDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
} 