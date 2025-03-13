import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';
import '../widgets/add_task_dialog.dart';
import '../services/file_service.dart';

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
            icon: const Icon(Icons.file_upload),
            tooltip: 'Import Tasks',
            onPressed: () => _importTasks(context),
          ),
          
          // Export button
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export Tasks',
            onPressed: () => _exportTasks(context),
          ),
          
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
  
  // Export tasks to a JSON file
  Future<void> _exportTasks(BuildContext context) async {
    final todoModel = Provider.of<TodoModel>(context, listen: false);
    
    if (todoModel.tasks.isEmpty) {
      _showSnackBar(context, 'No tasks to export');
      return;
    }
    
    // Show loading indicator
    final loadingDialogShown = _showLoadingDialog(context, 'Preparing to export...');
    
    try {      
      // Export tasks to JSON
      final jsonData = todoModel.exportTasksToJson();
      
      // Close the loading dialog if it's shown
      if (loadingDialogShown) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      // Show a new loading dialog for the actual export
      _showLoadingDialog(context, 'Exporting tasks...');
      
      final filePath = await FileService.exportToJson(jsonData, context);
      
      // Always close loading dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      // Show success or error message
      if (filePath != null) {
        _showSnackBar(context, 'Tasks exported to: $filePath');
      } else {
        _showSnackBar(context, 'Storage permission required for exporting tasks');
      }
    } catch (e) {
      // Make sure loading dialog is closed
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _showSnackBar(context, 'Error: ${e.toString()}');
    }
  }
  
  // Import tasks from a JSON file
  Future<void> _importTasks(BuildContext context) async {
    // Show loading indicator
    final loadingDialogShown = _showLoadingDialog(context, 'Preparing to import...');
    
    try {
      // Import tasks from JSON
      final jsonString = await FileService.importFromJson(context);
      
      // Close the loading dialog if it's shown
      if (loadingDialogShown) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (jsonString != null) {
        // Show a new loading dialog for the actual import
        _showLoadingDialog(context, 'Importing tasks...');
        
        // Import the tasks into the model
        await Provider.of<TodoModel>(context, listen: false)
            .importTasksFromJson(jsonString);
        
        // Always close loading dialog
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        
        _showSnackBar(context, 'Tasks imported successfully');
      } else {
        _showSnackBar(context, 'Storage permission required for importing tasks');
      }
    } catch (e) {
      // Make sure loading dialog is closed
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _showSnackBar(context, 'Error importing: ${e.toString()}');
    }
  }
  
  // Show a loading dialog
  bool _showLoadingDialog(BuildContext context, String message) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(message),
              ],
            ),
          );
        },
      );
      return true;
    } catch (e) {
      debugPrint('Error showing dialog: $e');
      return false;
    }
  }
  
  // Show a snackbar with a message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
}
