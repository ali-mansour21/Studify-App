import 'package:flutter/material.dart';

class StateWidget extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  const StateWidget(
      {super.key,
      required this.count,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: Colors.black),
        const SizedBox(height: 3),
        Text(
          count,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
