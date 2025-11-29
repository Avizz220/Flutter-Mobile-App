class NotificationModel {
  final String notificationID;
  final String userID;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? taskID;

  NotificationModel({
    required this.notificationID,
    required this.userID,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.taskID,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationID,
      'userID': userID,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'taskID': taskID,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationID: json['notificationID'] ?? '',
      userID: json['userID'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      taskID: json['taskID'],
    );
  }
}
