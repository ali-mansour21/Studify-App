import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Hello, Ali',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Materials',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
            ),
            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF3786A8),
                      child: Container(
                        width: 105,
                        height: 140,
                        child: const Column(
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
            )
          ],
        ),
      ),
    );
  }
}
