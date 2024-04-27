import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData iconData;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.iconData,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black45, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(iconData),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
