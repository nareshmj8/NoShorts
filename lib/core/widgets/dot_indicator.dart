import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int position;
  final int currentPage;

  const DotIndicator({
    super.key,
    required this.position,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentPage = position == currentPage;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use appropriate colors based on theme
    final activeColor = isDarkMode ? Colors.white : Colors.black;
    final inactiveColor =
        isDarkMode
            ? Colors.white.withOpacity(0.3)
            : Colors.black.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? activeColor : inactiveColor,
      ),
    );
  }
}

class DotIndicatorRow extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const DotIndicatorRow({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => DotIndicator(position: index, currentPage: currentPage),
      ),
    );
  }
}
