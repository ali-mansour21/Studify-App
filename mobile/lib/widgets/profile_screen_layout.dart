import 'package:flutter/material.dart';

class ProfileLayout extends StatelessWidget {
  final List<Widget> children;
  final double height;
  const ProfileLayout({super.key, required this.children, this.height = 500});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: children,
        ),
      ),
    );
  }
}
