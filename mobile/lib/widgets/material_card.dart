import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';

class MyWidget extends StatelessWidget {
  final MaterialItem materialItem;
  const MyWidget({super.key, required this.materialItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Image.asset('assets/Studify-logo.png', fit: BoxFit.cover),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Text(
              materialItem.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
