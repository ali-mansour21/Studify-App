class Topic {
  final String title;
  final String content;

  Topic({required this.title, required this.content});
}

class Assignment {
  final String title;
  final String description;
  final DateTime dueDate;

  Assignment(
      {required this.title, required this.description, required this.dueDate});
}

class Material {
  final String title;
  final List<Topic> topics;
  final List<Assignment> assignments;

  Material(
      {required this.title, required this.topics, required this.assignments});
}

class ClassData {
  final String title;
  final String description;
  final List<Material> materials;

  ClassData(
      {required this.title,
      required this.description,
      required this.materials});
}
