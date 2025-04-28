import 'package:flutter/services.dart';
import 'category_item.dart';

/// A class that provides access to topics from the topics_list.txt file
class TopicData {
  /// Map of category names to their list of topic items
  static final Map<String, List<CategoryItem>> _topicItems = {};

  /// Indicates if the data has been loaded
  static bool _isLoaded = false;

  /// Load all topic data from the text file
  static Future<void> initialize() async {
    if (_isLoaded) return;

    try {
      // Load the topic data from the assets
      final String textData = await rootBundle.loadString(
        'assets/data/topic_list.txt',
      );

      // Split by double newlines to separate sections more effectively
      final List<String> sections = textData.split('\n\n');

      String currentCategory = '';
      String categoryDescription = '';
      List<CategoryItem> currentItems = [];

      for (final section in sections) {
        final List<String> lines = section.split('\n');

        for (final line in lines) {
          final trimmedLine = line.trim();

          // Skip empty lines
          if (trimmedLine.isEmpty) {
            continue;
          }

          // Category header (e.g., "## 1. AI Story Game Master")
          if (trimmedLine.startsWith('## ')) {
            // Save previous category before starting a new one
            if (currentCategory.isNotEmpty && currentItems.isNotEmpty) {
              _topicItems[currentCategory] = List.from(currentItems);
            }

            // Extract new category title (remove the ## and number)
            final headerMatch = RegExp(
              r'## \d+\. (.+)',
            ).firstMatch(trimmedLine);
            if (headerMatch != null) {
              currentCategory = headerMatch.group(1)!.trim();
              currentItems = [];
              print('Parsed category: $currentCategory');
            }
          }
          // Category description (e.g., "*"Use AI to create your own role-playing adventures and fantasy worlds."*")
          else if (trimmedLine.startsWith('*"') && trimmedLine.endsWith('"*')) {
            categoryDescription =
                trimmedLine.substring(2, trimmedLine.length - 2).trim();
            print('Parsed description: $categoryDescription');
          }
          // Topic item (e.g., 1. "Generate a haunted space station RPG plot using ChatGPT.")
          else if (RegExp(r'^\d+\. "(.+)"').hasMatch(trimmedLine)) {
            final match = RegExp(r'^\d+\. "(.+?)"').firstMatch(trimmedLine);
            if (match != null && currentCategory.isNotEmpty) {
              final title = match.group(1)!;
              currentItems.add(
                CategoryItem(
                  title: title,
                  description:
                      categoryDescription, // Use the category description as a fallback
                ),
              );
            }
          }
        }
      }

      // Save the last category
      if (currentCategory.isNotEmpty && currentItems.isNotEmpty) {
        _topicItems[currentCategory] = List.from(currentItems);
      }

      print('Total categories loaded: ${_topicItems.length}');
      _topicItems.forEach((key, value) {
        print('$key: ${value.length} topics');
      });

      _isLoaded = true;
    } catch (e) {
      print('Error loading topic data: $e');
      _isLoaded = true; // Set to true to avoid repeated loading attempts
    }
  }

  /// Returns the list of topics for a given category
  static Future<List<CategoryItem>> getTopicsForCategory(
    String category,
  ) async {
    await initialize();
    return _topicItems[category] ?? [];
  }

  /// Returns the list of all available category names
  static Future<List<String>> getAllCategories() async {
    await initialize();
    return _topicItems.keys.toList();
  }
}
