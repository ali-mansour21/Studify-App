import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';

class MaterialScreen extends StatelessWidget {
  final MaterialItem material;
  const MaterialScreen({super.key, required this.material});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, "/home");
          },
        ),
        title: Text(
          material.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: material.topics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              material.topics[index],
              style: const TextStyle(color: Colors.black),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Handle the tap here
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey.shade300,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          );
        },
      ),
    );
  }
}
