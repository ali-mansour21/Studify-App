import 'package:flutter/material.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/screens/student_topics_screen.dart';

class MaterialCard extends StatelessWidget {
  final MaterialItem materialItem;
  const MaterialCard({super.key, required this.materialItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentTopicScreen(material: materialItem)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'assets/student_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Color(0xFF3786A8).withOpacity(0.55),
                  child: Text(
                    materialItem.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
