import 'package:flutter/material.dart';
import 'package:mobile/providers/material_provider.dart';
import 'package:mobile/screens/edit_screen.dart';
import 'package:mobile/screens/student_class_screen.dart';
import 'package:mobile/screens/student_materials_screen.dart';
import 'package:mobile/widgets/navigation_bar.dart';
import 'package:mobile/widgets/profile_screen_layout.dart';
import 'package:mobile/widgets/state_layout.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MaterialsProvider>(context, listen: false);
      provider.fetchStudnetMaterials(context);
    });
  }

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.settings, color: Colors.white),
          )
        ],
      ),
      body: ProfileLayout(
        children: [
          const Positioned(
            top: -65,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: 60,
              child: Text('AM',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
          const Positioned(
            top: 70,
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
            top: 125,
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
            padding: const EdgeInsets.only(top: 210),
            shrinkWrap: true,
            children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Material'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  var materials =
                      Provider.of<MaterialsProvider>(context, listen: false)
                          .studentMaterials;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => StudentMaterialScreen(
                              materials: materials,
                            )),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.class_),
                title: const Text('Classes'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const StudentClassScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
              ),
            ]).toList(),
          )
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onNavItemSelected,
      ),
    );
  }
}
