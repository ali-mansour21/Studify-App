import 'package:mobile/models/topic_material.dart';
import 'package:mobile/utilities/configure.dart';

class ClassTopic implements Topic {
  @override
  final String title;
  @override
  final String content;
  @override
  final String? attachmentUrl;

  ClassTopic({required this.title, required this.content, this.attachmentUrl});
  factory ClassTopic.fromJson(Map<String, dynamic> json) {
    String? attachmentPath = json['attachment'];
    const String imageBaseUrl = IMAGE_BASE_URL;

    return ClassTopic(
      title: json['title'],
      content: json['content'],
      attachmentUrl:
          attachmentPath != null ? imageBaseUrl + attachmentPath : null,
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
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String? attachmentUrl;

  Assignment(
      {required this.title,
      required this.content,
      required this.id,
      this.attachmentUrl});
  factory Assignment.fromJson(Map<String, dynamic> json) {
    String? attachmentPath = json['attachment'];
    const String imageBaseUrl = IMAGE_BASE_URL;
    print(attachmentPath);
    return Assignment(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      attachmentUrl:
          attachmentPath != null ? imageBaseUrl + attachmentPath : null,
    );
  }
}

class Material {
  final int id;
  final String title;
  final List<ClassTopic> topics;
  final List<Assignment> assignments;

  Material(
      {required this.id,
      required this.title,
      required this.topics,
      required this.assignments});
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
      id: json['id'],
      title: json['name'],
      topics: topicsList,
      assignments: assignmentsList,
    );
  }
}

class ClassData {
  final int id;
  final String title;
  final String description;
  final List<Material> materials;
  final List<Person> people;

  ClassData(
      {required this.title,
      required this.id,
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
      id: json['id'],
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
