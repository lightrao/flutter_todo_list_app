import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/todo_model.dart';
import 'services/database/database_helper.dart';
import 'screens/todo_list_page.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create database helper
  final dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoModel(dbHelper),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do List', 
      home: const TodoListPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
