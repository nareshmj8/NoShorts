import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopicListTile extends StatelessWidget {
  final Map<String, dynamic> topic;
  final VoidCallback onTap;

  // Colors
  static const Color primaryColor = Color(0xFF7209B7);

  const TopicListTile({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenHeight < 600;

    return Card(
      margin: EdgeInsets.symmetric(
        vertical:
            isTablet ? (isLandscape ? 6.0 : 8.0) : (isSmallScreen ? 4.0 : 6.0),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFE0E0E0), width: 0.5),
      ),
      elevation: 0.5,
      // Wrap with Semantics for better accessibility
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Category: ${topic['title']}',
        excludeSemantics: false,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20.0 : 16.0,
            vertical:
                isTablet
                    ? (isLandscape ? 8.0 : 12.0)
                    : (isSmallScreen ? 6.0 : 8.0),
          ),
          leading: Container(
            width:
                isTablet ? (isLandscape ? 48 : 56) : (isSmallScreen ? 40 : 48),
            height:
                isTablet ? (isLandscape ? 48 : 56) : (isSmallScreen ? 40 : 48),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                isTablet ? (isLandscape ? 24 : 28) : (isSmallScreen ? 20 : 24),
              ),
            ),
            child: Center(
              child: Text(
                topic['emoji'],
                style: TextStyle(
                  fontSize:
                      isTablet
                          ? (isLandscape ? 24 : 28)
                          : (isSmallScreen ? 20 : 24),
                ),
                semanticsLabel:
                    null, // Prevent emoji from being read by screen readers
              ),
            ),
          ),
          title: Text(
            topic['title'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize:
                  isTablet
                      ? (isLandscape ? 16 : 18)
                      : (isSmallScreen ? 14 : 16),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size:
                isTablet ? (isLandscape ? 18 : 20) : (isSmallScreen ? 14 : 16),
            semanticLabel: 'View details',
          ),
          onTap: () {
            // Add haptic feedback for better UX
            HapticFeedback.lightImpact();
            onTap();
          },
          focusColor: primaryColor.withOpacity(0.1),
          hoverColor: primaryColor.withOpacity(0.05),
        ),
      ),
    );
  }
}
