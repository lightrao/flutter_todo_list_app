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
      appBar: AppBar(title: const Text('My To-Do List')),

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
}
