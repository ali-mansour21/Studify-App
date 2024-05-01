import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/widgets/navigation_bar.dart';
import 'package:mobile/widgets/state_layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3786A8),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3786A8), Color(0xFF3786A8)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              child: const Icon(Icons.settings, color: Colors.white),
            ),
          )
        ],
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 500, // Adjust the height as needed
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
            children: [
              const Positioned(
                top: -85,
                left: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 60,
                  child: Text('AM',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ),
              const Positioned(
                top: 45,
                left: 0,
                right: 0,
                child: Text(
                  'Ali Mansour',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StateWidget(
                      count: '13',
                      label: 'Rank',
                      icon: Icons.star,
                    ),
                    StateWidget(
                      count: '13',
                      label: 'Documents',
                      icon: Icons.document_scanner,
                    ),
                    StateWidget(
                      count: '13',
                      label: 'Comments',
                      icon: Icons.comment,
                    ),
                  ],
                ),
              ),
              ListView(
                padding: const EdgeInsets.only(top: 200),
                shrinkWrap: true,
                children: ListTile.divideTiles(context: context, tiles: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ]).toList(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onNavItemSelected,
      ),
    );
  }
}
