import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task.dart';

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