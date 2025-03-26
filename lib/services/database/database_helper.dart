import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task.dart';

/// DatabaseHelper class that handles all database operations for the todo app.
/// Follows the singleton pattern to ensure a single instance is used throughout the app.
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  // Database instance
  static Database? _database;
  
  // Table name as a constant
  static const String tableName = 'tasks';
  
  // Factory constructor to return the singleton instance
  factory DatabaseHelper() {
    return _instance;
  }
  
  // Named private constructor for internal use
  DatabaseHelper._internal();

  /// Gets the database instance, creating it if needed
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database - private implementation
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

  /// Gets all tasks from database
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(tableName);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  /// Adds a task to database
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(tableName, task.toMap());
  }

  /// Deletes a task from database by ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Deletes all tasks from database
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(tableName);
  }
  
  /// Updates an existing task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Gets a specific task by ID
  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  /// Closes the database connection
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
