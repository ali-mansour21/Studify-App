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

final List<ClassData> classInfo = [
  ClassData(
    title: "Biology 101",
    description: "An introductory course into the world of living organisms.",
    materials: [
      Material(
        title: "Cell Biology",
        topics: [
          Topic(
              title: "Cell Structure",
              content: "Detailed discussion on cell structure."),
          Topic(
              title: "Cell Function", content: "Exploring how cells function."),
        ],
        assignments: [
          Assignment(
            title: "Cell Diagram",
            description: "Draw and label parts of a cell.",
            dueDate: DateTime.now().add(const Duration(days: 7)),
          ),
          Assignment(
            title: "Cell Function Essay",
            description: "Write an essay on the function of mitochondria.",
            dueDate: DateTime.now().add(const Duration(days: 14)),
          ),
        ],
      ),
      Material(
        title: "Genetics",
        topics: [
          Topic(
              title: "DNA Replication",
              content: "Processes involved in DNA replication."),
          Topic(
              title: "Genetic Diseases", content: "Study of genetic diseases."),
        ],
        assignments: [
          Assignment(
            title: "Genetics Homework",
            description: "Complete the genetics worksheet.",
            dueDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ],
      ),
    ],
  ),
  // Additional ClassData objects can be added here if needed
];
