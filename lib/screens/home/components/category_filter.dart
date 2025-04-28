import 'package:flutter/material.dart';
import '../../../models/category_data.dart';
import '../../../models/category_item.dart';
import '../../../screens/category_detail/category_detail_screen.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  // Colors
  static const Color primaryColor = Color(0xFF7209B7);
  static const Color lightGray = Color(0xFFF5F5F5);

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // "All" category chip
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: selectedCategory == null,
                onSelected: (_) => onCategorySelected(null),
                backgroundColor: lightGray,
                selectedColor: primaryColor.withOpacity(0.15),
                checkmarkColor: primaryColor,
                labelStyle: TextStyle(
                  color:
                      selectedCategory == null ? primaryColor : Colors.black87,
                  fontWeight:
                      selectedCategory == null
                          ? FontWeight.w500
                          : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Category chips
            for (var category in categories)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    // First update selected category
                    onCategorySelected(category);

                    // Then navigate to category detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FutureBuilder<List<CategoryItem>>(
                              future: CategoryData.getItemsForCategory(
                                category,
                              ),
                              builder: (context, snapshot) {
                                // While waiting for data, show a loading indicator
                                if (!snapshot.hasData) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: Text(category),
                                      leading: IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                    body: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                // When data is loaded, show the category detail screen
                                return CategoryDetailScreen(
                                  categoryTitle: category,
                                  items: snapshot.data!,
                                );
                              },
                            ),
                      ),
                    );
                  },
                  backgroundColor: lightGray,
                  selectedColor: primaryColor.withOpacity(0.15),
                  checkmarkColor: primaryColor,
                  labelStyle: TextStyle(
                    color:
                        selectedCategory == category
                            ? primaryColor
                            : Colors.black87,
                    fontWeight:
                        selectedCategory == category
                            ? FontWeight.w500
                            : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
