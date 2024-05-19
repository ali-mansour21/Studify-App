import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.iconData,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black45, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(
            iconData,
            color: const Color(0x000000).withOpacity(0.45),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: 1,
      ),
    );
  }
}
