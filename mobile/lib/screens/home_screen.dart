import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Hello, Ali',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
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
                        return const Card(
                          color: Color(0xFF3786A8),
                          child: SizedBox(
                            width: 105,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.medical_information,
                                  size: 48,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                    height:
                                        8), // Provides spacing between the icon and text
                                Text(
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
          )),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: '',
          ),
        ],
        selectedItemColor: const Color(0xFF3786A8),
      ),
    );
  }
}
