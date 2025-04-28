import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'category_item.dart';

/// A class that provides access to all category data in the app
class CategoryData {
  /// A map of category items, loaded lazily when needed
  static Map<String, List<CategoryItem>> _categoryItems = {};

  /// Indicates if the data has been loaded
  static bool _isLoaded = false;

  /// Loads all category data from the assets
  static Future<void> initialize() async {
    if (_isLoaded) return;

    try {
      // Load the category data from the assets
      final jsonString = await rootBundle.loadString(
        'assets/data/full_category_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse each category
      jsonData.forEach((categoryName, itemsData) {
        if (itemsData is Map<String, dynamic> &&
            itemsData.containsKey('topics')) {
          List<dynamic> topics = itemsData['topics'] as List<dynamic>;
          String emoji = itemsData['emoji'] as String? ?? '📚';

          _categoryItems[categoryName] =
              topics
                  .map(
                    (topic) => CategoryItem.fromMap({
                      'title': topic['title'],
                      'description': topic['description'],
                      'emoji': emoji,
                    }),
                  )
                  .toList();
        }
      });

      _isLoaded = true;
    } catch (e) {
      print('Error loading category data: $e');
      // Fallback to the initial data (first 6-7 items per category)
      _categoryItems = _initialData;
      _isLoaded = true;
    }
  }

  /// Returns the list of items for a given category
  static Future<List<CategoryItem>> getItemsForCategory(String category) async {
    await initialize();
    return _categoryItems[category] ?? [];
  }

  /// Returns a list of all category names
  static Future<List<String>> getAllCategories() async {
    await initialize();
    return _categoryItems.keys.toList();
  }

  /// Initial data with first 6-7 items for each category (used as fallback)
  static final Map<String, List<CategoryItem>> _initialData = {
    'AI Story Game Master': [
      CategoryItem(
        title: 'Generate a haunted space station RPG plot using ChatGPT',
        description:
            'Create immersive sci-fi horror adventures with AI assistance',
        emoji: '👻',
      ),
      CategoryItem(
        title: 'Design a fantasy world where magic is powered by emotions',
        description: 'Build unique magical systems with emotional connections',
        emoji: '✨',
      ),
      CategoryItem(
        title: 'Use AI to invent a villain with 3 unpredictable flaws',
        description: 'Create complex antagonists with unique weaknesses',
        emoji: '🦹‍♂️',
      ),
      CategoryItem(
        title:
            'Build a \'choose your own adventure\' game in Twine + AI dialogues',
        description: 'Combine Twine with AI to create interactive narratives',
        emoji: '🎮',
      ),
      CategoryItem(
        title: 'Create a mystery where players must decode AI-generated poetry',
        description: 'Design puzzles using AI-generated verse and riddles',
        emoji: '🔍',
      ),
      CategoryItem(
        title: 'Generate 10 unique magical items with unexpected side effects',
        description:
            'Create balanced magical artifacts with interesting tradeoffs',
        emoji: '🔮',
      ),
      CategoryItem(
        title:
            'Build a fantasy tavern with AI-generated patrons, rumors, and quests',
        description:
            'Create a vibrant hub for your adventures with diverse characters',
        emoji: '🍺',
      ),
    ],
    'Old Photo Magic': [
      CategoryItem(
        title: 'Animate your grandparent\'s wedding photo with modern AI tools',
        description: 'Bring cherished family memories to life with animation',
        emoji: '💒',
      ),
      CategoryItem(
        title:
            'Guess the true colors of a black-and-white photo before AI reveals it',
        description: 'Test your imagination against AI colorization technology',
        emoji: '🎨',
      ),
      CategoryItem(
        title: 'Turn a vintage postcard into a 10-second \'living\' scene',
        description: 'Transform static postcards into brief animated videos',
        emoji: '✉️',
      ),
      CategoryItem(
        title: 'Restore a damaged photo using free AI tools (step-by-step)',
        description:
            'Learn to repair tears, scratches and fading in old photographs',
        emoji: '🔧',
      ),
      CategoryItem(
        title:
            'Colorize a family heirloom photo and surprise relatives with the results',
        description: 'Add authentic color to monochrome family treasures',
        emoji: '👪',
      ),
      CategoryItem(
        title: 'Create a 3D effect by adding depth to flat vintage photographs',
        description:
            'Transform 2D images into immersive three-dimensional scenes',
        emoji: '📏',
      ),
    ],
    'Low-Carbon Life': [
      CategoryItem(
        title: 'Calculate the CO2 savings of air-drying clothes for a month',
        description:
            'Quantify your environmental impact through simple habit changes',
        emoji: '👕',
      ),
      CategoryItem(
        title:
            'Redesign your coffee routine to cut waste (without sacrificing taste)',
        description:
            'Create an eco-friendly coffee experience that still delights',
        emoji: '☕',
      ),
      CategoryItem(
        title: 'Host a \'zero-power hour\' with candlelit games and stories',
        description:
            'Create memorable unplugged experiences with friends and family',
        emoji: '🕯️',
      ),
      CategoryItem(
        title: 'Challenge: Fit a week\'s trash into a mason jar',
        description:
            'Dramatically reduce waste through mindful consumption choices',
        emoji: '🗑️',
      ),
      CategoryItem(
        title:
            'Create a microseason food calendar based on local produce availability',
        description:
            'Align your diet with hyper-local seasonal eating patterns',
        emoji: '🍎',
      ),
      CategoryItem(
        title:
            'Try \'meat-free Monday\' with three 15-minute plant-based recipes',
        description:
            'Discover quick, satisfying meals that reduce carbon footprint',
        emoji: '🥗',
      ),
    ],
    // Remaining 26 categories with their initial items would be included here
  };
}
