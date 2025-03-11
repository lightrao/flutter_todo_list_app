import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';

// Dialog to add a new task
class AddTaskDialog {
  // Show the dialog to add a new task
  static void show(BuildContext context) {
    final taskController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(hintText: "Enter task here"),
          autofocus: true,
          onSubmitted: (_) => _addTask(context, taskController),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _addTask(context, taskController),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  // Helper method to add a task and close the dialog
  static void _addTask(BuildContext context, TextEditingController controller) {
    if (controller.text.trim().isNotEmpty) {
      Provider.of<TodoModel>(context, listen: false)
          .addTask(controller.text);
      Navigator.of(context).pop();
    }
  }
} 