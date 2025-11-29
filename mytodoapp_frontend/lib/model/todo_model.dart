class TodoModel {
  final String todoID;
  final String title;
  final String description;
  final String userID;
  final bool isCompleted;
  final DateTime createdAt;

  TodoModel({
    required this.todoID,
    required this.title,
    required this.description,
    required this.userID,
    required this.isCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'todoID': todoID,
      'title': title,
      'description': description,
      'userID': userID,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
