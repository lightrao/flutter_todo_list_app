import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';

class AddTaskDialog {
  static void show(BuildContext context) {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: "Enter task here"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.trim().isNotEmpty) {
                  Provider.of<TodoModel>(
                    context,
                    listen: false,
                  ).addTask(taskController.text.trim());
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
} 