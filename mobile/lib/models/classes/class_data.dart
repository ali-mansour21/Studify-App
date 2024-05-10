import 'package:mobile/models/topic_material.dart';

class ClassTopic implements Topic {
  @override
  final String title;
  @override
  final String content;

  ClassTopic({required this.title, required this.content});
  factory ClassTopic.fromJson(Map<String, dynamic> json) {
    return ClassTopic(
      title: json['title'],
      content: json['content'],
    );
  }
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

  Assignment({required this.title, required this.content});
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['title'],
      content: json['content'],
    );
  }
}

class Material {
  final String title;
  final List<ClassTopic> topics;
  final List<Assignment> assignments;

  Material(
      {required this.title, required this.topics, required this.assignments});
  factory Material.fromJson(Map<String, dynamic> json) {
    List<ClassTopic> topicsList = [];
    if (json['topics'] != null) {
      topicsList = (json['topics'] as List)
          .map<ClassTopic>((topicJson) => ClassTopic.fromJson(topicJson))
          .toList();
    }

    List<Assignment> assignmentsList = [];
    if (json['assignments'] != null) {
      assignmentsList = (json['assignments'] as List)
          .map<Assignment>(
              (assignmentJson) => Assignment.fromJson(assignmentJson))
          .toList();
    }

    return Material(
      title: json['name'],
      topics: topicsList,
      assignments: assignmentsList,
    );
  }
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
  factory ClassData.fromJson(Map<String, dynamic> json) {
    List<Material> materials = [];
    if (json['materials'] != null) {
      materials = (json['materials'] as List)
          .map<Material>((matJson) => Material.fromJson(matJson))
          .toList();
    }

    return ClassData(
      title: json['name'],
      description: json['description'],
      materials: materials,
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
    );
  }
}

final List<ClassData> classInfo = [
  ClassData(
    title: "Biology 101",
    description: "An introductory course into the world of living organisms.",
    materials: [
      Material(
        title: "Cell Biology",
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
          ),
          Assignment(
            title: "Cell Function Essay",
            content: "Write an essay on the function of mitochondria.",
          ),
        ],
      ),
      Material(
        title: "Genetics",
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
