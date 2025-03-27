import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/todo_model.dart';
import 'services/database/database_helper.dart';
import 'screens/todo_list_page.dart';

// Entry point of the application
void main() async {
  // Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the database
  final dbHelper = DatabaseHelper();
  // Access the database to ensure it's initialized
  // await dbHelper.database;
  
  // Run the app with TodoModel provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoModel(dbHelper),
      child: const TodoApp(),
    ),
  );
}

// Root widget of the application
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}
