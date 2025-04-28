import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../models/category_data.dart';
import '../../models/category_item.dart';
import '../../screens/category_detail/category_detail_screen.dart';
import '../../screens/premium/premium_screen.dart';
import '../topic_detail/topic_detail_screen.dart';
import 'components/app_theme.dart';
import 'components/home_bottom_navigation.dart';
import 'components/loading_skeletons.dart';
import 'components/topic_card.dart';
import 'components/topic_list_tile.dart';
import 'components/topic_search_delegate.dart';
import '../my_plans/my_plans_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  int _currentIndex = 0;

  // Add a flag to track view mode
  bool _isGridView = true;

  // Add loading state
  bool _isLoading = true;

  // Flag to track if initial animations have completed
  bool _initialAnimationsComplete = false;

  // Pre-computed topic cards to avoid rebuilding them
  final Map<String, Widget> _topicCardCache = {};

  // Pre-filter topics list for better search performance
  List<Map<String, dynamic>>? _filteredTopicsList;

  // Dynamic list of topics loaded from CategoryData
  List<Map<String, dynamic>> _topics = [];

  List<Map<String, dynamic>> get _filteredTopics {
    // Use cached results if available
    if (_filteredTopicsList != null) {
      return _filteredTopicsList!;
    }

    // Start with all topics or filtered by search
    List<Map<String, dynamic>> result;
    if (_searchQuery.isEmpty) {
      result = _topics;
    } else {
      // Convert search query to lowercase once for performance
      final lowerQuery = _searchQuery.toLowerCase();
      result =
          _topics
              .where(
                (topic) => topic['title'].toLowerCase().contains(lowerQuery),
              )
              .toList();
    }

    _filteredTopicsList = result;
    return result;
  }

  @override
  void initState() {
    super.initState();

    // Initialize pulsing animation for Premium tab with more performant settings
    _pulseController = AnimationController(
      duration: const Duration(
        milliseconds: 2000,
      ), // Slower animation to reduce CPU usage
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      // Reduced animation range
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Optimize search by using debounce
    _searchController.addListener(_onSearchChanged);

    // Add focus listener to better handle iOS focus
    _searchFocusNode.addListener(() {
      // This helps prevent iOS focus-related crashes by ensuring
      // proper focus state management
      if (!mounted) return;
      setState(() {
        // Just trigger a rebuild when focus changes
      });
    });

    // Schedule animation completion check
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Allow initial animations to run, then disable for better performance
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _initialAnimationsComplete = true;
          });
        }
      });

      // Load categories from CategoryData
      _loadCategories();
    });
  }

  // Load categories from CategoryData
  Future<void> _loadCategories() async {
    try {
      // Get all category names
      final categoryList = await CategoryData.getAllCategories();

      // Build the topics list with title and emoji
      final List<Map<String, dynamic>> loadedTopics = [];

      for (final category in categoryList) {
        final items = await CategoryData.getItemsForCategory(category);
        if (items.isNotEmpty) {
          loadedTopics.add({
            'title': category,
            'emoji': items.first.emoji ?? '📚',
          });
        }
      }

      if (mounted) {
        setState(() {
          _topics = loadedTopics;
          _isLoading = false;
          _filteredTopicsList = null; // Reset cache
          _topicCardCache.clear();
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Debounced search to avoid excessive rebuilds
  void _onSearchChanged() {
    // Invalidate cache
    _filteredTopicsList = null;

    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    // Cancel animations
    _pulseController.stop();
    _pulseController.dispose();

    // Remove listeners first before disposing controllers
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(() {});

    // Clean up text field resources
    _searchController.dispose();
    _searchFocusNode.dispose();

    // Clear caches
    _filteredTopicsList = null;
    _topicCardCache.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation to determine layout
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenHeight < 600;
    final textScaler = MediaQuery.textScalerOf(context);

    // Calculate safe area paddings to ensure content isn't obscured
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return Theme(
      data: AppTheme.lightTheme,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Discover categories',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontSize: textScaler.scale(
                  isTablet ? 24.0 : (isSmallScreen ? 18.0 : 20.0),
                ),
              ),
            ),
            actions: [
              // Wrap IconButton in a Focus widget to better handle iOS focus system
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  size: isTablet ? 28 : 24,
                  semanticLabel:
                      _isGridView
                          ? 'Switch to list view'
                          : 'Switch to grid view',
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              if (isTablet) const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search bar with adaptive width and positioning for different layouts
                Container(
                  width: double.infinity,
                  alignment: isTablet ? Alignment.center : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 16.0,
                    vertical:
                        isLandscape
                            ? (isSmallScreen ? 8.0 : 12.0)
                            : (isTablet ? 20.0 : 16.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600.0 : double.infinity,
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.search,
                      keyboardAppearance: Theme.of(context).brightness,
                      style: TextStyle(
                        fontSize: textScaler.scale(isSmallScreen ? 14.0 : 16.0),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        prefixIcon: Icon(
                          Icons.search,
                          size: textScaler.scale(
                            isTablet ? 26 : (isSmallScreen ? 20 : 22),
                          ),
                          color: AppTheme.primaryColor,
                        ),
                        contentPadding:
                            isTablet
                                ? EdgeInsets.symmetric(
                                  vertical: isLandscape ? 16.0 : 18.0,
                                  horizontal: 16.0,
                                )
                                : (isSmallScreen
                                    ? const EdgeInsets.symmetric(vertical: 8.0)
                                    : null),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12.0 : 8.0,
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12.0 : 8.0,
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12.0 : 8.0,
                          ),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Grid or list of topics
                Expanded(
                  child:
                      _filteredTopics.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: isTablet ? 64 : 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No matching categories found',
                                    style: TextStyle(
                                      fontSize: textScaler.scale(
                                        isTablet ? 18 : 16,
                                      ),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try a different search term',
                                    style: TextStyle(
                                      fontSize: textScaler.scale(
                                        isTablet ? 16 : 14,
                                      ),
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                          // Wrap list/grid in ExcludeFocus to prevent issues with iOS focus system
                          : ExcludeFocus(
                            child: RefreshIndicator(
                              color: AppTheme.primaryColor,
                              onRefresh: () async {
                                await Future.delayed(
                                  const Duration(milliseconds: 800),
                                );
                                if (mounted) {
                                  setState(() {
                                    _filteredTopicsList = null;
                                    _topicCardCache.clear();
                                  });
                                }
                                return Future.value();
                              },
                              child:
                                  _isGridView
                                      ? _isLoading
                                          ? const TopicGridSkeleton()
                                          : _buildTopicGrid(
                                            isTablet,
                                            isLandscape,
                                            isSmallScreen,
                                          )
                                      : _isLoading
                                      ? const TopicListSkeleton()
                                      : _buildTopicList(
                                        isTablet,
                                        isLandscape,
                                        isSmallScreen,
                                      ),
                            ),
                          ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: HomeBottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == _currentIndex) {
                // Don't transition if already on that tab
                return;
              }

              setState(() {
                _currentIndex = index;
              });

              // Handle tab changes
              switch (index) {
                case 0:
                  // Home/Explore tab - already there
                  break;
                case 1:
                  // My Plans tab
                  Navigator.push(
                    context,
                    _createTabRoute(const MyPlansScreen()),
                  ).then((value) {
                    setState(() {
                      _currentIndex = 0; // Return to Explore tab
                    });
                  });
                  break;
                case 2:
                  // Premium tab
                  Navigator.push(
                    context,
                    _createTabRoute(const PremiumScreen()),
                  ).then((value) {
                    setState(() {
                      _currentIndex = 0; // Return to Explore tab
                    });
                  });
                  break;
                case 3:
                  // Settings tab
                  Navigator.push(
                    context,
                    _createTabRoute(const SettingsScreen()),
                  ).then((returnedIndex) {
                    // When returning from Settings screen, check if a tab index was returned
                    if (returnedIndex != null && returnedIndex is int) {
                      setState(() {
                        _currentIndex = returnedIndex;
                      });
                    } else {
                      setState(() {
                        _currentIndex =
                            0; // Default to Explore tab when returning
                      });
                    }
                  });
              }
            },
            pulseController: _pulseController,
            pulseAnimation: _pulseAnimation,
          ),
        ),
      ),
    );
  }

  Widget _buildTopicGrid(bool isTablet, bool isLandscape, bool isSmallScreen) {
    // Calculate appropriate cross axis count based on screen width and orientation
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust columns based on screen size and orientation
    int crossAxisCount;
    if (isTablet) {
      if (isLandscape) {
        crossAxisCount = screenWidth >= 1100 ? 5 : (screenWidth >= 900 ? 4 : 3);
      } else {
        crossAxisCount = screenWidth >= 900 ? 4 : 3;
      }
    } else {
      crossAxisCount = isLandscape ? 3 : 2;
    }

    // Adjust aspect ratio for different layouts
    double childAspectRatio =
        isTablet
            ? (screenWidth > 1000 ? 1.4 : (isLandscape ? 1.3 : 1.2))
            : isLandscape
            ? 1.2
            : (isSmallScreen ? 0.9 : 1.0);

    return GridView.builder(
      primary: true,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isLandscape ? 12.0 : (isTablet ? 20.0 : 12.0),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isTablet ? (screenWidth > 900 ? 20 : 16) : 12,
        mainAxisSpacing: isTablet ? (screenWidth > 900 ? 20 : 16) : 12,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      cacheExtent: 500,
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        final topic = _filteredTopics[index];

        // If initial animations are complete, render without animations
        if (_initialAnimationsComplete) {
          return _getCachedTopicCard(topic);
        }

        // Only animate for initial loading
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _pulseController,
            curve: Interval(
              index * 0.02, // Stagger with minimal overlap
              1.0,
              curve: Curves.easeOut,
            ),
          ),
          child: _getCachedTopicCard(topic),
        );
      },
    );
  }

  Widget _buildTopicList(bool isTablet, bool isLandscape, bool isSmallScreen) {
    return ListView.builder(
      primary: true,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isLandscape ? 8.0 : (isTablet ? 12.0 : 8.0),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        final topic = _filteredTopics[index];

        // For tablets, we can use a more spacious layout
        if (isTablet) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: isLandscape ? 2.0 : 4.0),
            child: TopicListTile(
              topic: topic,
              onTap: () {
                // Navigate to category detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            TopicDetailScreen(categoryTitle: topic['title']),
                  ),
                );
              },
            ),
          );
        }

        return TopicListTile(
          topic: topic,
          onTap: () {
            // Navigate to category detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        TopicDetailScreen(categoryTitle: topic['title']),
              ),
            );
          },
        );
      },
    );
  }

  // Get a cached topic card or build and cache a new one
  Widget _getCachedTopicCard(Map<String, dynamic> topic) {
    final String key = topic['title'];
    if (!_topicCardCache.containsKey(key)) {
      _topicCardCache[key] = TopicCard(
        topic: topic,
        onTap: () {
          // Navigate to topic detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TopicDetailScreen(categoryTitle: topic['title']),
            ),
          );
        },
      );
    }
    return _topicCardCache[key]!;
  }

  PageRoute _createTabRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 150),
    );
  }
}
