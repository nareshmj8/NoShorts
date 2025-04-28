import 'package:flutter/material.dart';

// Custom search delegate for full-screen search
class TopicSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> topics;
  static const Color primaryColor = Color(0xFF7209B7);
  static const Color lightGray = Color(0xFFF5F5F5);

  // Cache filtered results for performance
  final Map<String, List<Map<String, dynamic>>> _cachedResults = {};

  TopicSearchDelegate(this.topics);

  // Static decoration to avoid rebuilding
  final BoxDecoration _decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor, size: 22),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: primaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
        fillColor: lightGray,
        filled: true,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, size: 22),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 22),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  List<Map<String, dynamic>> _getFilteredTopics() {
    // Use cached results if available
    if (_cachedResults.containsKey(query)) {
      return _cachedResults[query]!;
    }

    // If empty query, return all topics
    if (query.isEmpty) {
      return topics;
    }

    // Filter topics and cache results
    final lowerQuery = query.toLowerCase();
    final filtered =
        topics
            .where((topic) => topic['title'].toLowerCase().contains(lowerQuery))
            .toList();

    // Limit cache size to prevent memory issues
    if (_cachedResults.length > 10) {
      _cachedResults.remove(_cachedResults.keys.first);
    }

    _cachedResults[query] = filtered;
    return filtered;
  }

  Widget _buildSearchResults() {
    final filteredTopics = _getFilteredTopics();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0, // Square aspect ratio
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      cacheExtent: 500,
      itemCount: filteredTopics.length,
      itemBuilder: (context, index) {
        final topic = filteredTopics[index];
        return RepaintBoundary(
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                close(context, topic['title']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening: ${topic['title']}')),
                );
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 140),
                decoration: _decoration,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        topic['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic['title'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
