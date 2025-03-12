import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database/database_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Manages the state of tasks and provides database operations
class TodoModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper;
  List<Task> _tasks = [];

  // Constructor loads tasks from database on initialization
  TodoModel(this._dbHelper) {
    _loadTasks();
  }
  
  // Load all tasks from the database
  Future<void> _loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  // Getter for tasks list
  List<Task> get tasks => _tasks;

  // Add a new task
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    
    final task = Task(title: title.trim());
    final id = await _dbHelper.insertTask(task);
    
    // Add task with the ID returned from database
    _tasks.add(Task(id: id, title: title.trim()));
    notifyListeners();
  }

  // Remove a task at given index
  Future<void> removeTask(int index) async {
    if (index < 0 || index >= _tasks.length) return;
    
    final taskId = _tasks[index].id;
    if (taskId != null) {
      await _dbHelper.deleteTask(taskId);
      _tasks.removeAt(index);
      notifyListeners();
    }
  }
  
  // Clear all tasks from memory and database
  Future<void> clearAllTasks() async {
    await _dbHelper.deleteAllTasks();
    _tasks.clear();
    notifyListeners();
  }
  
  // Export tasks to a JSON file
  Future<File> exportTasksToJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/todo_tasks_${DateTime.now().millisecondsSinceEpoch}.json';
    
    // Convert tasks to a list of maps
    final List<Map<String, dynamic>> tasksMap = _tasks.map((task) => {
      'title': task.title,
    }).toList();
    
    // Convert to JSON and write to file
    final jsonString = jsonEncode(tasksMap);
    return File(path).writeAsString(jsonString);
  }
  
  // Export tasks to a CSV file
  Future<File> exportTasksToCsv() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/todo_tasks_${DateTime.now().millisecondsSinceEpoch}.csv';
    
    // Create CSV header
    final csvContent = StringBuffer('id,title\n');
    
    // Add each task
    for (var task in _tasks) {
      csvContent.writeln('${task.id},${task.title}');
    }
    
    // Write to file
    return File(path).writeAsString(csvContent.toString());
  }
  
  // Import tasks from a JSON file
  Future<void> importTasksFromJson(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> tasksList = jsonDecode(jsonString);
        
        // Clear existing tasks
        await clearAllTasks();
        
        // Add imported tasks
        for (var taskMap in tasksList) {
          await addTask(taskMap['title']);
        }
      }
    } catch (e) {
      rethrow; // Let the UI handle the error
    }
  }
  
  // Import tasks from a CSV file
  Future<void> importTasksFromCsv(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final csvString = await file.readAsString();
        final lines = csvString.split('\n');
        
        // Skip header line and remove empty lines
        final taskLines = lines.sublist(1).where((line) => line.trim().isNotEmpty);
        
        // Clear existing tasks
        await clearAllTasks();
        
        // Add imported tasks
        for (var line in taskLines) {
          final parts = line.split(',');
          if (parts.length >= 2) {
            // The title might contain commas, so join all parts after the first
            final title = parts.sublist(1).join(',').trim();
            await addTask(title);
          }
        }
      }
    } catch (e) {
      rethrow; // Let the UI handle the error
    }
  }
} 