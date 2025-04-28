import 'package:flutter/material.dart';
import '../../models/category_item.dart';
import '../../models/category_data.dart';

class TopicDetailScreen extends StatefulWidget {
  final String categoryTitle;

  const TopicDetailScreen({super.key, required this.categoryTitle});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  int? expandedIndex;
  bool _isLoading = true;
  List<CategoryItem> _topics = [];
  String _categoryDescription = '';

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    try {
      final topics = await CategoryData.getItemsForCategory(
        widget.categoryTitle,
      );
      if (mounted) {
        setState(() {
          _topics = topics;
          _isLoading = false;
          // Use the description from the first topic as they all share the same category description
          _categoryDescription =
              topics.isNotEmpty ? topics.first.description : '';
        });
      }
    } catch (e) {
      print('Error loading topics: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF5F5F5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.categoryTitle,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: false,
          ),

          // Topic description header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topics to explore',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_topics.length} available topics',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7209B7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _categoryDescription.isNotEmpty
                        ? _categoryDescription
                        : 'Explore different topics in this category',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator or empty state
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF7209B7)),
              ),
            )
          else if (_topics.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No topics available for this category',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            // Topics list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final topic = _topics[index];
                  final isExpanded = expandedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isExpanded
                                  ? const Color(0xFF7209B7).withOpacity(0.5)
                                  : const Color(0xFFEEEEEE),
                          width: 1,
                        ),
                        boxShadow:
                            isExpanded
                                ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7209B7,
                                    ).withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                expandedIndex = null;
                              } else {
                                expandedIndex = index;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        topic.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: const Color(0xFF666666),
                                    ),
                                  ],
                                ),

                                // Expanded content with button
                                if (isExpanded) ...[
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Generating plan for: ${topic.title}',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF7209B7,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Generate Plan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: _topics.length),
              ),
            ),
        ],
      ),
    );
  }
}
