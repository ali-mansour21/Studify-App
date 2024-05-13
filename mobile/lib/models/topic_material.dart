abstract class Topic {
   String get title;
  String get content;
  String? get attachmentUrl;
}

class NotesTopic implements Topic {
  final int id;
  @override
  final String title;
  @override
  final String content;
   @override
  final String? attachmentUrl;
  NotesTopic({required this.id, required this.title, required this.content, this.attachmentUrl});
  factory NotesTopic.fromJson(Map<String, dynamic> json) {
    return NotesTopic(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}
