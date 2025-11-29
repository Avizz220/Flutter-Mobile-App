class EventModel {
  final String eventID;
  final String userID;
  final String taskID;
  final String title;
  final String location;
  final DateTime eventDate;
  final String startTime;
  final String endTime;
  final String category;
  final String color;

  EventModel({
    required this.eventID,
    required this.userID,
    required this.taskID,
    required this.title,
    required this.location,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'userID': userID,
      'taskID': taskID,
      'title': title,
      'location': location,
      'eventDate': eventDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'color': color,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventID: json['eventID'] ?? '',
      userID: json['userID'] ?? '',
      taskID: json['taskID'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      eventDate: DateTime.parse(json['eventDate'] ?? DateTime.now().toIso8601String()),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      category: json['category'] ?? '',
      color: json['color'] ?? '',
    );
  }
}
