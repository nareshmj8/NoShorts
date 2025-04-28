import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TopicGridSkeleton extends StatelessWidget {
  final int itemCount;

  const TopicGridSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenWidth > screenHeight;

    // Calculate appropriate columns based on screen size and orientation
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
    final double childAspectRatio =
        isTablet ? (isLandscape ? 1.3 : 1.2) : (isLandscape ? 1.2 : 1.0);

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isLandscape ? 12.0 : (isTablet ? 20.0 : 12.0),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isTablet ? 16 : 12,
        mainAxisSpacing: isTablet ? 16 : 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
          ),
        );
      },
    );
  }
}

class TopicListSkeleton extends StatelessWidget {
  final int itemCount;

  const TopicListSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenHeight < 600;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isLandscape ? 8.0 : (isTablet ? 12.0 : 8.0),
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isLandscape ? 4.0 : (isTablet ? 8.0 : 6.0),
            ),
            child: Container(
              height:
                  isTablet
                      ? (isLandscape ? 70 : 85)
                      : (isSmallScreen ? 65 : 75),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
