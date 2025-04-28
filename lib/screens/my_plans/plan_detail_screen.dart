import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> plan;

  const PlanDetailScreen({Key? key, required this.plan}) : super(key: key);

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  // Dummy YouTube links for demonstration
  final List<String> _youtubeLinks = [
    'https://www.youtube.com/watch?v=mJeNghZXtMo',
    'https://www.youtube.com/watch?v=aircAruvnKk',
    'https://www.youtube.com/watch?v=tIXDik5SGsI',
    'https://www.youtube.com/watch?v=F4WWukTWmXA',
    'https://www.youtube.com/watch?v=yFQ3B1WNnGM',
    'https://www.youtube.com/watch?v=jGwO_UgTS7I',
    'https://www.youtube.com/watch?v=cKxRvEZd3Mw',
    'https://www.youtube.com/watch?v=R4OlXb9aTvQ',
    'https://www.youtube.com/watch?v=ER8oKX5myE0',
    'https://www.youtube.com/watch?v=CsL0XNZ_lbQ',
  ];

  // Extended dummy steps with more detailed content
  final List<String> _extendedSteps = [
    'Introduction to core concepts and terminology',
    'Setting up your environment and tools for practical learning',
    'Understanding data structures and fundamentals',
    'Building your first basic project step-by-step',
    'Exploring advanced techniques and methodologies',
    'Implementing best practices for optimization',
    'Practical problem-solving techniques and challenges',
    'Connecting with APIs and external resources',
    'Testing and validation methodologies',
    'Deploying your project and next steps',
  ];

  // Track completed steps
  List<bool> completedSteps = List.generate(10, (index) => false);

  // Calculate progress percentage
  double get progressPercentage {
    int completed = completedSteps.where((isComplete) => isComplete).length;
    return completed / completedSteps.length;
  }

  // Mark all steps as complete/incomplete
  void toggleAllSteps() {
    // If all are checked, uncheck all. If some or none are checked, check all.
    bool allChecked = completedSteps.every((isComplete) => isComplete);

    setState(() {
      for (int i = 0; i < completedSteps.length; i++) {
        completedSteps[i] = !allChecked;
      }
    });

    // Show a feedback message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allChecked
              ? 'All steps marked as incomplete'
              : 'All steps marked as complete',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          widget.plan['topic'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Mark all as complete',
            onPressed: toggleAllSteps,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      '${(progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7209B7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF7209B7),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${completedSteps.where((isComplete) => isComplete).length} of ${completedSteps.length} steps completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Steps content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Learning Steps heading
                    Text(
                      'Learning Steps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Steps list with connected timeline
                    ...List.generate(
                      10, // Show 10 steps in detailed view
                      (index) => _buildTimelineStep(index, cardColor),
                    ),

                    // Bottom padding
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(int index, Color cardColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String step =
        index < _extendedSteps.length
            ? _extendedSteps[index]
            : 'Additional learning step ${index + 1}';
    String youtubeLink =
        index < _youtubeLinks.length ? _youtubeLinks[index] : _youtubeLinks[0];

    // Determine if this is the last item
    bool isLastItem = index == 9;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left timeline column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Custom checkbox implementation
                InkWell(
                  onTap: () {
                    setState(() {
                      completedSteps[index] = !completedSteps[index];
                    });
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color:
                          completedSteps[index]
                              ? const Color(0xFF7209B7)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            completedSteps[index]
                                ? const Color(0xFF7209B7)
                                : Colors.grey.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child:
                        completedSteps[index]
                            ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                            : null,
                  ),
                ),
                // Connect line to next step (except for last item)
                if (!isLastItem)
                  Expanded(
                    child: Container(
                      width: 2,
                      color:
                          completedSteps[index] && completedSteps[index + 1]
                              ? const Color(0xFF7209B7).withOpacity(0.6)
                              : const Color(0xFF7209B7).withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),

          // Content column
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step text
                  Text(
                    step,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          completedSteps[index]
                              ? FontWeight.normal
                              : FontWeight.w500,
                      height: 1.4,
                      decoration:
                          completedSteps[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      decorationColor: Colors.grey,
                      decorationThickness: 2,
                      color:
                          completedSteps[index]
                              ? Colors.grey
                              : isDarkMode
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // YouTube link - simple with icon
                  InkWell(
                    onTap: () => _launchYouTubeUrl(youtubeLink),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7209B7).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Color(0xFF7209B7),
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Watch tutorial',
                            style: TextStyle(
                              color: const Color(0xFF7209B7),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchYouTubeUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch video')));
    }
  }
}
