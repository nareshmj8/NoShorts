import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopicCard extends StatelessWidget {
  final Map<String, dynamic> topic;
  final VoidCallback onTap;

  // Colors
  static const Color primaryColor = Color(0xFF7209B7);

  const TopicCard({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenHeight < 600;

    // Reuse the same decoration for all cards
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
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

    // Adjust styles based on device and orientation
    final TextStyle emojiStyle = TextStyle(
      fontSize: isTablet ? (isLandscape ? 32 : 36) : (isSmallScreen ? 24 : 28),
    );

    final BoxConstraints containerConstraints = BoxConstraints(
      minHeight:
          isTablet
              ? (isLandscape ? 140 : 160)
              : (isLandscape ? 130 : (isSmallScreen ? 120 : 140)),
    );

    // Adjust padding based on screen size and orientation
    final EdgeInsets contentPadding = EdgeInsets.all(
      isTablet ? (isLandscape ? 16.0 : 20.0) : (isSmallScreen ? 12.0 : 16.0),
    );

    // Use FocusableActionDetector to properly handle focus across platforms
    return FocusableActionDetector(
      focusNode: FocusNode(skipTraversal: false, canRequestFocus: true),
      autofocus: false,
      onShowFocusHighlight: (focused) {
        // This can help with focus debugging if needed
        debugPrint('TopicCard focus highlight: $focused');
      },
      child: Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFFE0E0E0), width: 0.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            splashColor: primaryColor.withOpacity(0.1),
            highlightColor: primaryColor.withOpacity(0.05),
            hoverColor: primaryColor.withOpacity(0.05),
            focusColor: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            child: Semantics(
              button: true,
              enabled: true,
              label: 'Category: ${topic['title']}',
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          topic['emoji'],
                          style: const TextStyle(fontSize: 28),
                          semanticsLabel: null, // Prevent emoji from being read
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      topic['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
