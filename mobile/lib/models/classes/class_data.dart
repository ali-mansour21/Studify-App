import 'package:mobile/models/topic_material.dart';

class ClassTopic implements Topic {
  @override
  final String title;
  @override
  final String content;

  ClassTopic({required this.title, required this.content});
}

class Person {
  final String name;
  final String role;
  final String profileImage;

  Person({required this.name, required this.role, required this.profileImage});
}

class Assignment implements Topic {
  @override
  final String title;
  @override
  final String content;
  final DateTime dueDate;

  Assignment(
      {required this.title, required this.content, required this.dueDate});
}

class Material {
  final String title;
  final String description;
  final List<ClassTopic> topics;
  final List<Assignment> assignments;

  Material(
      {required this.title,
      required this.description,
      required this.topics,
      required this.assignments});
}

class ClassData {
  final String title;
  final String description;
  final List<Material> materials;
  final List<Person> people;

  ClassData(
      {required this.title,
      required this.description,
      required this.materials,
      required this.people});
}

final List<ClassData> classInfo = [
  ClassData(
    title: "Biology 101",
    description: "An introductory course into the world of living organisms.",
    materials: [
      Material(
        title: "Cell Biology",
        description: "Hello world",
        topics: [
          ClassTopic(
              title: "Cell Structure",
              content: "Detailed discussion on cell structure."),
          ClassTopic(
              title: "Cell Function", content: "Exploring how cells function."),
        ],
        assignments: [
          Assignment(
            title: "Cell Diagram",
            content: "Draw and label parts of a cell.",
            dueDate: DateTime.now().add(const Duration(days: 7)),
          ),
          Assignment(
            title: "Cell Function Essay",
            content: "Write an essay on the function of mitochondria.",
            dueDate: DateTime.now().add(const Duration(days: 14)),
          ),
        ],
      ),
      Material(
        title: "Genetics",
        description: "Hello world",
        topics: [
          ClassTopic(
              title: "DNA Replication",
              content: "Processes involved in DNA replication."),
          ClassTopic(
              title: "Genetic Diseases", content: "Study of genetic diseases."),
        ],
        assignments: [
          Assignment(
            title: "Genetics Homework",
            content: "Complete the genetics worksheet.",
            dueDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ],
      ),
    ],
    people: [
      Person(
        name: "Dr. Emily White",
        role: "Teacher",
        profileImage:
            "Dr. Emily White is a leading expert in Genetics and Cell Biology.",
      ),
      Person(
        name: "John Doe",
        role: "Student",
        profileImage:
            "John Doe assists in the lab and coordinates student projects.",
      ),
    ],
  )
];
