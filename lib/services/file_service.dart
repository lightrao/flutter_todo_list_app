import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  // Get appropriate storage permission based on platform
  static Future<PermissionStatus> _getStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 10 (API 29) and above, request manageExternalStorage 
      // if broad file access (like Downloads) is needed.
      // Note: This permission requires special declaration in AndroidManifest.xml
      // and justification for Google Play Store review.
      return await Permission.manageExternalStorage.request();      
    } else {
      // For iOS and other platforms
      return await Permission.storage.request();
    }
  }

  // Export data to a JSON file using file_saver
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

      // Create suggested filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Suggest a base name, the user can change it in the save dialog
      final fileName = 'todo_list_$timestamp'; 

      // Convert String data to Uint8List
      final bytes = utf8.encode(jsonData);

      // Use file_saver to open the save dialog
      // The user chooses the final location and confirms the name.
      String? savedPath = await FileSaver.instance.saveAs(
        name: fileName, // Suggested name
        bytes: bytes,
        ext: 'json', // File extension
        // Using MimeType.text as JSON is text-based.
        // Alternatively, could use MimeType.other and customMimeType: 'application/json'
        mimeType: MimeType.text, 
      );

      // file_saver returns the path if saved, null if cancelled/failed.
      return savedPath; 

    } catch (e) {
      debugPrint('Error exporting file with file_saver: $e');
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
