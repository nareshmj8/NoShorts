import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/screens/home/components/home_bottom_navigation.dart';
import 'package:noshorts/screens/premium/premium_screen.dart';
import 'package:noshorts/screens/settings/settings_screen.dart';
import 'package:noshorts/screens/my_plans/plan_detail_screen.dart';

class MyPlansScreen extends ConsumerStatefulWidget {
  const MyPlansScreen({super.key});

  @override
  ConsumerState<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends ConsumerState<MyPlansScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Dummy data for plans
  final List<Map<String, dynamic>> _dummyPlans = [
    {
      'category': 'AI & Machine Learning',
      'topic': 'Machine Learning Fundamentals',
      'description': 'A beginner-friendly guide to machine learning concepts',
      'steps': [
        'Introduction to ML concepts',
        'Understanding data preparation',
        'Building your first model',
        'Model evaluation techniques',
        'Deployment basics',
      ],
      'date': 'Created on May 15, 2023',
    },
    {
      'category': 'Python Basics for Data Science',
      'topic': 'Data Analysis with Pandas',
      'description': 'Master data manipulation with Python Pandas library',
      'steps': [
        'Setting up your environment',
        'Data importing and cleaning',
        'DataFrame operations',
        'Data visualization with Matplotlib',
        'Statistical analysis',
      ],
      'date': 'Created on June 2, 2023',
    },
    {
      'category': 'Introduction to Web Development',
      'topic': 'Building Responsive Websites',
      'description': 'Learn to create websites that work on any device',
      'steps': [
        'HTML/CSS fundamentals',
        'Responsive design principles',
        'CSS frameworks overview',
        'Mobile-first approach',
        'Testing across devices',
      ],
      'date': 'Created on June 10, 2023',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // My Plans Heading
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Plans',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          '${_dummyPlans.length} plans',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plans content
                  Expanded(child: _buildPlansContent()),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 1, // Set to My Plans tab
        onTap: (index) {
          if (index != 1) {
            // If tapping the Explore tab (0), simply go back to home screen
            if (index == 0) {
              Navigator.pop(context); // Just go back without parameters
            } else {
              // For other tabs (Premium or Settings), navigate directly
              // without going back to home first
              if (index == 2) {
                // Navigate to Premium
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const PremiumScreen()),
                );
              } else if (index == 3) {
                // Navigate to Settings
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const SettingsScreen()),
                );
              }
            }
          }
        },
        pulseController: _animationController,
        pulseAnimation: _fadeAnimation,
      ),
    );
  }

  Widget _buildPlansContent() {
    return _dummyPlans.isEmpty
        ? _buildEmptyPlansState()
        : ListView.builder(
          itemCount: _dummyPlans.length,
          itemBuilder: (context, index) {
            final plan = _dummyPlans[index];
            return _buildPlanCard(plan);
          },
        );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          plan['topic'],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // Show delete confirmation dialog
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Delete Plan'),
                    content: Text(
                      'Are you sure you want to delete "${plan['topic']}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Delete plan logic would go here
                          Navigator.pop(context);

                          // Show confirmation snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plan['topic']} deleted'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetailScreen(plan: plan),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyPlansState() {
    // Placeholder for when no plans are available
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_list_bulleted,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'No learning plans yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore topics and create your first plan!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, 0), // Go to Explore tab
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Explore Topics'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
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
