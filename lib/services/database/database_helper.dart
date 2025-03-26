import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task.dart';

// Handles all database operations for the todo app
class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'tasks';
  
  // Constructor - can be used to initialize the database
  DatabaseHelper() {
    // Initialize database lazily through the getter
  }

  // Get the database instance, creating it if needed
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)');
      },
    );
  }

  // Get all tasks from database
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(tableName);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // Add a task to database
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(tableName, task.toMap());
  }

  // Delete a task from database
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Delete all tasks from database
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(tableName);
  }

  // Close the database connection
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
