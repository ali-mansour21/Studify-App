import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/topic_material.dart';
import 'package:mobile/screens/class_detail_screen.dart';
import 'package:mobile/screens/material_screen.dart';
import 'package:mobile/widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<MaterialItem> materials = [
    MaterialItem(
      id: 1,
      title: 'Material 1',
      topics: [
        NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
        NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
      ],
    ),
    MaterialItem(
      id: 2,
      title: 'Material 2',
      topics: [
        NotesTopic(id: 1, title: 'Topic 1', content: 'Content for topic 1'),
        NotesTopic(id: 2, title: 'Topic 2', content: 'Content for topic 2'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const int notificationCount = 3;
    final List<String> notifications = [
      "Your appointment is tomorrow.",
      "New updates are available.",
      "Reminder: Meeting at 3 PM today."
    ];
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hello, Ali',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600),
                      ),
                      PopupMenuButton(
                          icon: Stack(
                            children: <Widget>[
                              ClipOval(
                                child: Container(
                                  width: 47,
                                  height: 47,
                                  color: const Color(0xFF3786A8),
                                  child: const Icon(Icons.notifications,
                                      size: 24, color: Colors.white),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  child: const Text(
                                    '$notificationCount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          iconSize: 24,
                          color: Colors.white,
                          onSelected: (String value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value),
                              ),
                            );
                          },
                          offset: const Offset(0, 60),
                          itemBuilder: (BuildContext context) {
                            return notifications.map((String notification) {
                              return PopupMenuItem<String>(
                                value: notification,
                                child: Text(notification),
                              );
                            }).toList();
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {},
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD0D0D0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Materials',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          MaterialItem material = materials[index];
                          return Card(
                            color: const Color(0xFF3786A8),
                            child: SizedBox(
                              width: 105,
                              height: 140,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MaterialScreen(material: material)),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.medical_information,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      material.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Available Classes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    itemCount: classInfo.length,
                    itemBuilder: (context, index) {
                      final classData = classInfo[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.class_,
                            color: Colors.blue,
                            size: 50,
                          ),
                          title: Text(classData.title),
                          subtitle: Text(classData.description),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClassDetailScreen(
                                        classDetail: classData,
                                      )),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
          bottomNavigationBar: CustomNavigationBar(
              currentIndex: _selectedIndex, onItemSelected: _onNavItemSelected),
        ));
  }
}
