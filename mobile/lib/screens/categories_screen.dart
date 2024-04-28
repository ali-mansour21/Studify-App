import 'package:flutter/material.dart';
import 'package:mobile/widgets/card_category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Set<String> _selectedCategories = {};

  void _handleCategoryTap(String title) {
    setState(() {
      if (_selectedCategories.contains(title)) {
        _selectedCategories.remove(title);
      } else {
        _selectedCategories.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryCard> cards = [
      CategoryCard(
        title: 'Math',
        imagePath: 'assets/categories/Math.png',
        isSelected: _selectedCategories.contains('Math'),
        onSelect: () => _handleCategoryTap('Math'),
      ),
      CategoryCard(
        title: 'Arabic',
        imagePath: 'assets/categories/Arabic.png',
        isSelected: _selectedCategories.contains('Arabic'),
        onSelect: () => _handleCategoryTap('Arabic'),
      ),
      CategoryCard(
        title: 'English',
        imagePath: 'assets/categories/English.png',
        isSelected: _selectedCategories.contains('English'),
        onSelect: () => _handleCategoryTap('English'),
      ),
      CategoryCard(
        title: 'Geo',
        imagePath: 'assets/categories/Geo.png',
        isSelected: _selectedCategories.contains('Geo'),
        onSelect: () => _handleCategoryTap('Geo'),
      ),
      CategoryCard(
        title: 'History',
        imagePath: 'assets/categories/History.png',
        isSelected: _selectedCategories.contains('History'),
        onSelect: () => _handleCategoryTap('History'),
      ),
      CategoryCard(
        title: 'Science',
        imagePath: 'assets/categories/Science.png',
        isSelected: _selectedCategories.contains('Science'),
        onSelect: () => _handleCategoryTap('Science'),
      ),
      CategoryCard(
        title: 'French',
        imagePath: 'assets/categories/French.png',
        isSelected: _selectedCategories.contains('French'),
        onSelect: () => _handleCategoryTap('French'),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFF3786A8))),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose a category according to your expertise',
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0), // Add some spacing
            Expanded(
              // GridView must be wrapped in Expanded when in a Column
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
                children: cards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
