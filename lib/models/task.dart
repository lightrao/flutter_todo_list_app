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