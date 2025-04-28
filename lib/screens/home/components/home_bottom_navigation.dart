import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  // Colors
  static const Color primaryColor = Color(0xFF7209B7);
  static const Color badgeRed = Colors.red;

  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.pulseController,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Add extra padding for devices with home indicators or notches
    final bottomNavPadding = bottomPadding > 0 ? bottomPadding : 8.0;

    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.dark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomNavPadding),
      // Use Row instead of BottomNavigationBar for better focus control
      child: ExcludeFocus(
        excluding: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Explore Tab
            _buildNavItem(
              context: context,
              icon: Icons.explore,
              title: 'Explore',
              index: 0,
              isTablet: isTablet,
            ),

            // My Plans Tab
            _buildNavItem(
              context: context,
              icon: Icons.bookmark,
              title: 'My Plans',
              index: 1,
              isTablet: isTablet,
            ),

            // Premium Tab with animation
            _buildNavItem(
              context: context,
              icon: Icons.workspace_premium,
              title: 'Premium',
              index: 2,
              isTablet: isTablet,
              useAnimation: true,
            ),

            // Settings Tab
            _buildNavItem(
              context: context,
              icon: Icons.settings,
              title: 'Settings',
              index: 3,
              isTablet: isTablet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int index,
    required bool isTablet,
    bool useAnimation = false,
  }) {
    final isSelected = currentIndex == index;
    final iconSize = isTablet ? 28.0 : 24.0;
    final textSize = isTablet ? 12.0 : 10.0;

    Widget content = Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 14.0 : 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryColor : Colors.grey,
            size: iconSize,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.grey,
              fontSize: textSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );

    // Apply animation if needed
    if (useAnimation) {
      content = ScaleTransition(scale: pulseAnimation, child: content);
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap(index);
        },
        focusColor: primaryColor.withOpacity(0.1),
        hoverColor: primaryColor.withOpacity(0.05),
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Semantics(
          label: title,
          button: true,
          selected: isSelected,
          child: content,
        ),
      ),
    );
  }
}
