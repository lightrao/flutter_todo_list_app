import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  // Export data to a JSON file
  static Future<String?> exportToJson(String jsonData) async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          return 'Storage permission denied';
        }
      }
      
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Create filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/todo_list_$timestamp.json';
      
      // Write the file
      final file = File(path);
      await file.writeAsString(jsonData);
      
      return path;
    } catch (e) {
      print('Error exporting file: $e');
      return null;
    }
  }
  
  // Import data from a JSON file
  static Future<String?> importFromJson() async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          return null;
        }
      }
      
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await file.readAsString();
      }
      
      return null;
    } catch (e) {
      print('Error importing file: $e');
      return null;
    }
  }
} 