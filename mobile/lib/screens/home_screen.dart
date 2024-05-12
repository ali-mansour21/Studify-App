import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/classes/class_data.dart';
import 'package:mobile/models/material_model.dart';
import 'package:mobile/models/users/user_data.dart';
import 'package:mobile/providers/class_provider.dart';
import 'package:mobile/providers/material_provider.dart';
import 'package:mobile/providers/notification_provider.dart';
import 'package:mobile/screens/class_detail_screen.dart';
import 'package:mobile/screens/material_screen.dart';
import 'package:mobile/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String baseUrl = "http://192.168.0.104:8001/api";

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  int _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MaterialsProvider>(context, listen: false);
      provider.fetchMaterials(context);
      final classProvider =
          Provider.of<StudyClassProvider>(context, listen: false);
      classProvider.loadClasses(context);
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.getNotifications(context);
    });
  }

  void _onSearchChanged(String query) async {
    String token = Provider.of<UserData>(context, listen: false).jwtToken;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await http.post(
        Uri.parse('$baseUrl/dataSearch'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'keyWord': query}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          _updateProvidersWithSearchResults(responseData);
        } else {
          print('Search failed: ${responseData['message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    });
  }

  void _updateProvidersWithSearchResults(Map<String, dynamic> responseData) {
    final materialProvider =
        Provider.of<MaterialsProvider>(context, listen: false);
    final classProvider =
        Provider.of<StudyClassProvider>(context, listen: false);

    List<MaterialItem> materials = (responseData['data']['studyNotes'] as List)
        .map((data) => MaterialItem.fromJson(data))
        .toList();
    List<ClassData> classes = (responseData['data']['classes'] as List)
        .map((data) => ClassData.fromJson(data))
        .toList();

    materialProvider.updateMaterials(materials);
    classProvider.updateClasses(classes);
  }

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<MaterialsProvider>(
            builder: (context, materialProvider, child) {
              return Consumer<StudyClassProvider>(
                builder: (context, classProvider, child) {
                  if (materialProvider.isLoading || classProvider.is_loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildHeader(context),
                      buildSearchBar(),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Materials',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: materialProvider.materials.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'No materials available',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : buildMaterialList(materialProvider, context),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Available Classes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: classProvider.studyClasses.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'No classes available',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: classProvider.studyClasses.length,
                                itemBuilder: (context, index) {
                                  final classData =
                                      classProvider.studyClasses[index];
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
                                            builder: (context) =>
                                                ClassDetailScreen(
                                              classDetail: classData,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _selectedIndex,
          onItemSelected: _onNavItemSelected,
        ),
      ),
    );
  }

  Widget buildHeader(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hello, Ali',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          buildNotificationsIcon(context),
        ],
      ),
    );
  }

  Widget buildNotificationsIcon(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    final notifications = notificationProvider.notifications;

    return PopupMenuButton(
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
              constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
              child: Text(
                notifications.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      iconSize: 24,
      color: Colors.white,
      onSelected: (String value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value)));
      },
      onCanceled: () {
        notificationProvider.clearNotifications();
      },
      offset: const Offset(0, 60),
      itemBuilder: (BuildContext context) {
        return notifications.map((notification) {
          return PopupMenuItem<String>(
            value: notification.content,
            child: Text(
              notification.content,
              style: TextStyle(fontSize: 13),
            ),
          );
        }).toList();
      },
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
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
              borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
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
    );
  }
}

Widget buildMaterialList(
    MaterialsProvider materialsProvider, BuildContext context) {
  return SizedBox(
    height: 120,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: materialsProvider.materials.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 5),
          child: buildMaterialCard(materialsProvider.materials[index], context),
        );
      },
    ),
  );
}

Widget buildMaterialCard(MaterialItem material, context) {
  return Container(
    width: 105,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFF3786A8),
      borderRadius: BorderRadius.circular(8),
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialScreen(
              material: material,
            ),
          ),
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
          const SizedBox(height: 10),
          Text(
            material.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildClassList(StudyClassProvider classProvider) {
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: classProvider.studyClasses.length,
    itemBuilder: (context, index) {
      final classData = classProvider.studyClasses[index];
      return Card(
        child: ListTile(
          leading: const Icon(Icons.class_, color: Colors.blue, size: 50),
          title: Text(classData.title),
          subtitle: Text(classData.description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassDetailScreen(classDetail: classData),
              ),
            );
          },
        ),
      );
    },
  );
}
