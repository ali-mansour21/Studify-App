class Notification {
  final int id;
  final String content;
  final String date;
  Notification({required this.id, required this.content, required this.date});
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      content: json['content'],
      date: json['created_at'],
    );
  }
}
