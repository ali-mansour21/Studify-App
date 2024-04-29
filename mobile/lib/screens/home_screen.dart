import 'package:flutter/material.dart';
import 'package:mobile/widgets/navigationbar.dart';

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
                                  color: const Color(
                                      0xFF3786A8), // Background color
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          // Define the action when filter icon is pressed
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD0D0D0))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Materials',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFF3786A8),
                          child: SizedBox(
                            width: 105,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.medical_information,
                                      size: 48,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                    height:
                                        8), // Provides spacing between the icon and text
                                const Text(
                                  'Material',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Available Classes',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.class_,
                            color: Colors.blue,
                            size: 50,
                          ),
                          title: const Text('Title'),
                          subtitle: const Text('this is a small description'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomNavigationBar(
              currentIndex: _selectedIndex, onItemSelected: _onNavItemSelected),
        ));
  }
}
