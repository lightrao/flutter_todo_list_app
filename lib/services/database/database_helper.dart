import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task.dart';

/// DatabaseHelper class that handles all database operations for the todo app.
/// Follows the singleton pattern to ensure a single instance is used throughout the app.
class DatabaseHelper {
  // Singleton pattern implementation
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  DatabaseHelper._internal();
  
  factory DatabaseHelper() => _instance;

  // Database and table constants
  static Database? _database;
  static const String _tableName = 'tasks';
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _databaseName = 'todo_database.db';
  static const int _databaseVersion = 1;

  /// Gets the database instance, creating it if needed
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  /// Initializes the database - private implementation
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Creates the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $_columnTitle TEXT NOT NULL
      )
    ''');
  }

  /// Gets all tasks from database
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  /// Adds a task to database
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(_tableName, task.toMap());
  }

  /// Deletes a task from database by ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  /// Deletes all tasks from database
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(_tableName);
  }

  /// Updates an existing task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      _tableName,
      task.toMap(),
      where: '$_columnId = ?',
      whereArgs: [task.id],
    );
  }

  /// Gets a specific task by ID
  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
      limit: 1,
    );

    return maps.isNotEmpty ? Task.fromMap(maps.first) : null;
  }

  /// Closes the database connection
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}
