class MaterialCategory {
  final int id;
  final String name;
  final String categoryImage;

  MaterialCategory(
      {required this.id, required this.name, required this.categoryImage});

  factory MaterialCategory.fromJson(Map<String, dynamic> json) {
    return MaterialCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      categoryImage: json['category_image'] as String,
    );
  }
}
