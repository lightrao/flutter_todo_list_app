import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database/database_helper.dart';

class TodoModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper;
  List<Task> _tasks = [];

  TodoModel(this._dbHelper) {
    _loadTasks();
  }
  
  Future<void> _loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  List<Task> get tasks => _tasks;

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    final id = await _dbHelper.insertTask(task);
    _tasks.add(Task(id: id, title: title));
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    final taskId = _tasks[index].id;
    if (taskId != null) {
      await _dbHelper.deleteTask(taskId);
    }
    _tasks.removeAt(index);
    notifyListeners();
  }
} 