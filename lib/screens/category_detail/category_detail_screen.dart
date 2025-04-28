import 'package:flutter/material.dart';
import '../../models/category_item.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryTitle;
  final List<CategoryItem> items;

  const CategoryDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.items,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with AutomaticKeepAliveClientMixin {
  int? expandedIndex;

  // Cache expensive widgets
  final Map<int, Widget> _itemCache = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(CategoryDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear cache if items change
    if (oldWidget.items != widget.items) {
      _itemCache.clear();
    }
  }

  @override
  void dispose() {
    _itemCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // Get screen size for responsiveness
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width >= 768;
    final bool isLandscape = screenSize.width > screenSize.height;

    // Calculate adaptive values
    final double horizontalPadding = isTablet ? 32.0 : 16.0;
    final double itemPadding = isTablet ? 24.0 : 20.0;
    final double titleFontSize = isTablet ? 32.0 : 28.0;
    final double itemTitleFontSize = isTablet ? 18.0 : 16.0;
    final double descriptionFontSize = isTablet ? 16.0 : 15.0;

    // For grid layout on tablets - limit to 2 columns max
    final int gridCrossAxisCount = isLandscape && isTablet ? 2 : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        // Use ClampingScrollPhysics instead of BouncingScrollPhysics
        physics: const ClampingScrollPhysics(),
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF5F5F5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.all(isTablet ? 8.0 : 4.0),
            ),
            title: Text(
              widget.categoryTitle,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 24.0 : 22.0,
              ),
            ),
            centerTitle: false,
          ),

          // Category description header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topics to explore',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.items.length} available topics',
                    style: TextStyle(
                      fontSize: isTablet ? 18.0 : 16.0,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items list - grid on tablet, list on phone
          widget.items.isEmpty
              ? const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No items available for this category',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
              : gridCrossAxisCount > 1
              // Grid layout for tablets in landscape with better memory handling
              ? SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  24,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  // Use more efficient delegate
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Use cached widget if available
                      if (_itemCache.containsKey(index) &&
                          expandedIndex != index) {
                        return _itemCache[index]!;
                      }

                      // Create and cache topic item widget
                      final itemWidget = _buildTopicItem(
                        index,
                        widget.items[index],
                        itemPadding,
                        itemTitleFontSize,
                        descriptionFontSize,
                      );

                      // Only cache non-expanded items to save memory
                      if (expandedIndex != index) {
                        _itemCache[index] = itemWidget;
                      }

                      return itemWidget;
                    },
                    childCount: widget.items.length,
                    // Add this to improve recycling
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                  ),
                ),
              )
              // List layout for phones and portrait tablets
              : SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (_itemCache.containsKey(index) &&
                          expandedIndex != index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _itemCache[index]!,
                        );
                      }

                      final itemWidget = _buildTopicItem(
                        index,
                        widget.items[index],
                        itemPadding,
                        itemTitleFontSize,
                        descriptionFontSize,
                      );

                      if (expandedIndex != index) {
                        _itemCache[index] = itemWidget;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: itemWidget,
                      );
                    },
                    childCount: widget.items.length,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(
    int index,
    CategoryItem item,
    double padding,
    double titleSize,
    double descriptionSize,
  ) {
    final isExpanded = expandedIndex == index;

    return RepaintBoundary(
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
                      color: const Color(0xFF7209B7).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                  // Clear cached item when expanded
                  _itemCache.remove(index);
                  expandedIndex = index;
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                          // Limit text to reduce memory usage
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF666666),
                        size: titleSize + 4,
                      ),
                    ],
                  ),

                  // Description text - always visible
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: descriptionSize,
                      color: const Color(0xFF666666),
                      height: 1.4,
                    ),
                    // Limit text to prevent memory issues
                    maxLines: isExpanded ? 10 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Expanded content with button
                  if (isExpanded) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'Generate Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7209B7),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Generating plan for: ${item.title}',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
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
  }
}
