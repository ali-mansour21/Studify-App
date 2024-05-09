import 'package:flutter/material.dart';
import 'package:mobile/widgets/card_category.dart';
import 'package:mobile/widgets/mainbutton.dart';
import 'package:mobile/services/api_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Set<int> _selectedCategoryIds = {};
  List<dynamic> categoryData = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final List<dynamic> categories = await _apiService.getAllCategories();
      setState(() {
        categoryData = categories; // Save the data
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')));
    }
  }

  void _handleCategoryTap(int id, String name) {
    setState(() {
      if (_selectedCategoryIds.contains(id)) {
        _selectedCategoryIds.remove(id);
      } else {
        _selectedCategoryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Categories'),
        leading: IconButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFF3786A8))),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose a category according to your expertise',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                      children: categoryData
                          .map((category) => CategoryCard(
                                title: category['name'],
                                imagePath:
                                    'assets/categories/${category['name']}.png',
                                isSelected: _selectedCategoryIds
                                    .contains(category['id']),
                                onSelect: () => _handleCategoryTap(
                                    category['id'], category['name']),
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                  buttonColor: const Color(0xFF3786A8),
                  buttonText: "Next",
                  onPressed: () {
                    print('the selected ids are: $_selectedCategoryIds');
                    // Navigator.pushReplacementNamed(context, '/home');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
