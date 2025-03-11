import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  
  Future<Database> initDatabase() async {
    // Get the path to the database file
    String path = join(await getDatabasesPath(), 'todo_database.db');
    
    // Open/create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the tasks table when the database is created
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
      },
    );
  }
  
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }
  
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
    );
  }
  
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Task {
  final int? id;
  final String title;
  
  Task({this.id, required this.title});
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

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

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  void _addTask(BuildContext context) {
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
        onPressed: () => _addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
