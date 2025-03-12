import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';
import '../widgets/add_task_dialog.dart';
import '../services/file_service.dart';
import 'dart:io';

// Main screen displaying the list of tasks
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        actions: [
          // Import button
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import Tasks',
            onPressed: () => _showImportDialog(context),
          ),
          
          // Export button
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Tasks',
            onPressed: () => _showExportDialog(context),
          ),
          
          // Clear all button
          Consumer<TodoModel>(
            builder: (context, todoModel, _) {
              // Only show the clear button if there are tasks
              if (todoModel.tasks.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear All',
                onPressed: () {
                  _showClearConfirmationDialog(context);
                },
              );
            },
          ),
        ],
      ),

      // Display tasks or empty state message
      body: Consumer<TodoModel>(builder: (context, todoModel, _) {
        final tasks = todoModel.tasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Text("No tasks yet! Tap + to add a task."),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) =>
              _buildTaskItem(context, tasks, index),
        );
      }),

      // Add task button
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTaskDialog.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build a single task list item
  Widget _buildTaskItem(BuildContext context, tasks, int index) {
    return ListTile(
      title: Text(tasks[index].title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          Provider.of<TodoModel>(context, listen: false).removeTask(index);
        },
      ),
    );
  }
  
  // Show confirmation dialog before clearing all tasks
  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text(
          'Are you sure you want to delete all tasks? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TodoModel>(context, listen: false).clearAllTasks();
              Navigator.of(ctx).pop();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
  
  // Show dialog for importing tasks
  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Tasks'),
        content: const Text('Choose a file format to import'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _importTasks(context, 'json');
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _importTasks(context, 'csv');
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  // Import tasks from a file
  Future<void> _importTasks(BuildContext context, String fileType) async {
    try {
      final String? filePath = await FileService.pickFile(
        allowedExtensions: [fileType],
      );
      
      if (filePath != null) {
        final todoModel = Provider.of<TodoModel>(context, listen: false);
        
        if (fileType == 'json') {
          await todoModel.importTasksFromJson(filePath);
        } else if (fileType == 'csv') {
          await todoModel.importTasksFromCsv(filePath);
        }
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tasks imported successfully')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing tasks: ${e.toString()}')),
        );
      }
    }
  }
  
  // Show dialog for exporting tasks
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Tasks'),
        content: const Text('Choose a file format to export'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _exportTasks(context, 'json');
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _exportTasks(context, 'csv');
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  // Export tasks to a file
  Future<void> _exportTasks(BuildContext context, String fileType) async {
    try {
      final todoModel = Provider.of<TodoModel>(context, listen: false);
      File exportedFile;
      
      if (fileType == 'json') {
        exportedFile = await todoModel.exportTasksToJson();
      } else {
        exportedFile = await todoModel.exportTasksToCsv();
      }
      
      // Share the exported file
      await FileService.shareFile(exportedFile);
      
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting tasks: ${e.toString()}')),
        );
      }
    }
  }
}
