import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noshorts/core/theme/app_theme.dart';

enum StepIconType { dot, progressRing, checkmark }

class WalkthroughStep extends StatelessWidget {
  final StepIconType iconType;
  final String text;
  final int animationDelay;

  const WalkthroughStep({
    super.key,
    required this.iconType,
    required this.text,
    required this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
            children: [
              _buildIcon(context, iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          )
          .animate()
          .fadeIn(
            duration: 400.ms,
            curve: Curves.easeOut,
            delay: animationDelay.ms,
          )
          .slideX(
            begin: -10,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
            delay: animationDelay.ms,
          ),
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    switch (iconType) {
      case StepIconType.dot:
        return Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: 1000.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.2, 1.2),
                end: const Offset(0.8, 0.8),
                duration: 1000.ms,
                curve: Curves.easeInOut,
              ),
        );

      case StepIconType.progressRing:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 1500.ms, curve: Curves.linear),
        );

      case StepIconType.checkmark:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 16, color: iconColor)
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 800.ms, curve: Curves.easeInOut)
              .then()
              .fadeOut(duration: 800.ms, curve: Curves.easeInOut),
        );
    }
  }
}
