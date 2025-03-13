import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  // Get appropriate storage permission based on platform
  static Future<PermissionStatus> _getStoragePermission() async {
    // For Android 13+ (API level 33+), use more granular permissions
    if (Platform.isAndroid) {
      // For Android, check both storage permissions
      final status = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
      
      // Return the most restrictive status
      if (status[Permission.manageExternalStorage] != null && 
          status[Permission.manageExternalStorage]!.isGranted) {
        return PermissionStatus.granted;
      }
      
      return status[Permission.storage] ?? PermissionStatus.denied;
    } else {
      // For iOS and other platforms
      return await Permission.storage.request();
    }
  }

  // Export data to a JSON file
  static Future<String?> exportToJson(String jsonData, BuildContext context) async {
    try {
      // Request appropriate storage permission
      final status = await _getStoragePermission();
      
      // Handle permission result
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          // User selected "Never ask again", direct them to settings
          await _showPermissionSettingsDialog(context);
        }
        return null; // Return null to indicate export failure due to permissions
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
      debugPrint('Error exporting file: $e');
      return null;
    }
  }

  // Import data from a JSON file
  static Future<String?> importFromJson(BuildContext context) async {
    try {
      // Request appropriate storage permission
      final status = await _getStoragePermission();
      
      // Handle permission result
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          // User selected "Never ask again", direct them to settings
          await _showPermissionSettingsDialog(context);
        }
        return null; // Return null to indicate import failure due to permissions
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
      debugPrint('Error importing file: $e');
      return null;
    }
  }
  
  // Show dialog to direct user to app settings for permission
  static Future<void> _showPermissionSettingsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is required for importing/exporting tasks. '
          'Please enable it in app settings.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
