import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';
import '../widgets/add_task_dialog.dart';

// Main screen displaying the list of tasks
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        actions: [
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
}
