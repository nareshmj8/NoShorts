import 'package:flutter/material.dart';
import 'package:noshorts/core/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isAnimated;
  final double? fontSize;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isAnimated = false,
    this.fontSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              height: height,
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontSize: fontSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
