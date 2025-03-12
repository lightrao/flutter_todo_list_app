import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../services/database/database_helper.dart';

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
  
  // Export all tasks to a JSON string
  String exportTasksToJson() {
    final List<Map<String, dynamic>> taskList = _tasks.map((task) => task.toMap()).toList();
    return jsonEncode(taskList);
  }
  
  // Import tasks from a JSON string
  Future<void> importTasksFromJson(String jsonString) async {
    try {
      final List<dynamic> taskList = jsonDecode(jsonString);
      
      // Clear existing tasks
      await clearAllTasks();
      
      // Add each task from the imported list
      for (final taskMap in taskList) {
        final task = Task.fromMap(taskMap);
        await addTask(task.title);
      }
      
      // Reload tasks from database to ensure consistency
      await _loadTasks();
    } catch (e) {
      print('Error importing tasks: $e');
      rethrow; // Rethrow to handle in UI
    }
  }
} 