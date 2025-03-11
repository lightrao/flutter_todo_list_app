import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_model.dart';
import '../widgets/add_task_dialog.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TodoModel>(context).tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('My To-Do List')),
      body:
          tasks.isEmpty
              ? const Center(child: Text("No tasks yet!"))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<TodoModel>(
                          context,
                          listen: false,
                        ).removeTask(index);
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTaskDialog.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
} 