import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  const CustomNavigationBar(
      {super.key, required this.currentIndex, required this.onItemSelected});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF3786A8)), // Use the color you want here
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: '',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
