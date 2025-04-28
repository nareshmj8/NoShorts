import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/screens/home/components/home_bottom_navigation.dart';
import 'package:noshorts/screens/my_plans/my_plans_screen.dart';
import 'package:noshorts/screens/premium/premium_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Settings Heading
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 28 : 22,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),

                  // Settings content with improved UI
                  Expanded(child: _buildSettingsContent(isTablet, isDarkMode)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 3, // Set to Settings tab
        onTap: (index) {
          if (index != 3) {
            // If tapping the Explore tab (0), simply go back to home screen
            if (index == 0) {
              Navigator.pop(context); // Just go back without parameters
            } else {
              // For other tabs (My Plans or Premium), navigate directly
              // without going back to home first
              if (index == 1) {
                // Navigate to My Plans
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const MyPlansScreen()),
                );
              } else if (index == 2) {
                // Navigate to Premium
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const PremiumScreen()),
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

  Widget _buildSettingsContent(bool isTablet, bool isDarkMode) {
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final double sectionSpacing = isTablet ? 28.0 : 24.0;
    final double tileVerticalPadding = isTablet ? 6.0 : 4.0;

    return ListView(
      padding: const EdgeInsets.only(bottom: 16), // Add padding at the bottom
      children: [
        // Account Settings Section
        _buildSectionHeader('Account', isTablet),
        _buildSettingsCard(cardColor, [
          _buildSettingsTile(
            icon: Icons.account_circle_outlined,
            title: 'Signed in as Gmail',
            subtitle: 'Active',
            verticalPadding: tileVerticalPadding,
            trailing: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: Colors.green, size: 18),
            ),
            onTap: null,
          ),
          _buildDivider(isDarkMode),
          _buildSettingsTile(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            verticalPadding: tileVerticalPadding,
            trailing: Transform.scale(
              scale: 0.9, // Slightly smaller switch
              child: Switch(
                value: true, // Default to on
                activeColor: const Color(0xFF7209B7), // Match app theme
                onChanged: (value) {
                  // Toggle notifications would be implemented here
                },
              ),
            ),
            onTap: null,
          ),
          _buildDivider(isDarkMode),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Sign Out',
            verticalPadding: tileVerticalPadding,
            titleColor: Colors.red.shade600,
            onTap: () {
              // Sign out logic would be implemented here
              // Potentially show a confirmation dialog
              _showSignOutDialog(context);
            },
          ),
        ]),

        SizedBox(height: sectionSpacing),

        // About & Support Section
        _buildSectionHeader('About & Support', isTablet),
        _buildSettingsCard(cardColor, [
          _buildSettingsTile(
            icon: Icons.support_agent_outlined,
            title: 'Contact Support',
            verticalPadding: tileVerticalPadding,
            subtitle: 'Get help with your account or plans',
            onTap: () {},
          ),
          _buildDivider(isDarkMode),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About NoShorts',
            verticalPadding: tileVerticalPadding,
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          _buildDivider(isDarkMode),
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            verticalPadding: tileVerticalPadding,
            onTap: () {},
          ),
          _buildDivider(isDarkMode),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            verticalPadding: tileVerticalPadding,
            onTap: () {},
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        bottom: isTablet ? 12 : 8,
        top: isTablet ? 12 : 8,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: isTablet ? 15 : 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(Color cardColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Clip content to rounded corners
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
    double verticalPadding = 4.0,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final leadingIconColor =
        isDarkMode ? Colors.purple.shade200 : const Color(0xFF7209B7);
    final leadingBackgroundColor =
        isDarkMode
            ? Colors.purple.withOpacity(0.2)
            : const Color(0xFF7209B7).withOpacity(0.1);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: verticalPadding,
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: leadingBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 24, color: leadingIconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17,
          color: titleColor ?? (isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              )
              : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right, size: 24, color: Colors.grey.shade500)
              : null),
      onTap: onTap,
      // Add visual feedback on tap
      splashColor: leadingIconColor.withOpacity(0.1),
      hoverColor: leadingIconColor.withOpacity(0.05),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 70,
      endIndent: 16,
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                // TODO: Implement actual sign-out logic here
                // e.g., call auth service, clear state, navigate to onboarding
                print('Sign out action triggered');
              },
            ),
          ],
        );
      },
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
