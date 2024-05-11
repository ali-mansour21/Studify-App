class UserNotification {
  final int id;
  final String content;
  final String date;
  UserNotification({required this.id, required this.content, required this.date});
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      content: json['content'],
      date: json['created_at'],
    );
  }
}
