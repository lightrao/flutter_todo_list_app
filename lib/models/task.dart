// A simple model to represent a task
class Task {
  final int? id;
  final String title;
  
  Task({this.id, required this.title});
  
  // Convert a Task to a Map for database operations
  Map<String, dynamic> toMap() => {'id': id, 'title': title};
  
  // Create a Task from a Map (from database)
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }
} 