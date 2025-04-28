import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noshorts/core/widgets/dot_indicator.dart';
import 'package:noshorts/core/widgets/gradient_button.dart';
import 'package:noshorts/core/widgets/walkthrough_step.dart';
import 'package:noshorts/screens/onboarding/onboarding_screen_3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe gesture detection
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swiped from right to left (go forward)
          HapticFeedback.lightImpact();
          _navigateToNextScreen(context);
        } else if (details.primaryVelocity! > 0) {
          // Swiped from left to right (go back)
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        // Adding subtle gradient background for visual interest
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                const Color(0xFFF9FAFB),
                const Color(0xFFF3F4F6),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: true, // Ensure safe area at bottom
            child: Stack(
              children: [
                // Main structure with fixed button at bottom
                Column(
                  children: [
                    // Main scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Back button
                              Align(
                                alignment: Alignment.topLeft,
                                child: _buildBackButton(context),
                              ),

                              const SizedBox(height: 40),

                              // Logo in the center
                              Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 180,
                                      height: 180,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    duration: 600.ms,
                                    curve: Curves.easeOut,
                                  )
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1, 1),
                                  )
                                  .moveY(begin: 10, end: 0)
                                  .shimmer(delay: 1000.ms, duration: 1800.ms)
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .moveY(begin: 0, end: -5, duration: 1800.ms)
                                  .then()
                                  .moveY(begin: -5, end: 0, duration: 1800.ms),

                              const SizedBox(height: 40),

                              // Headline "No more endless scrolling"
                              Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                          spreadRadius: -2,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'No more endless scrolling.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayLarge?.copyWith(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    duration: 600.ms,
                                    curve: Curves.easeOut,
                                    delay: 300.ms,
                                  )
                                  .moveY(begin: 10, end: 0),

                              const SizedBox(height: 40),

                              // Three-step walkthrough
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Step 1
                                    const WalkthroughStep(
                                      iconType: StepIconType.dot,
                                      text:
                                          "Pick a topic (e.g., 'Learn Python')",
                                      animationDelay: 450,
                                    ),

                                    const Divider(height: 24, thickness: 0.5),

                                    // Step 2
                                    const WalkthroughStep(
                                      iconType: StepIconType.progressRing,
                                      text: "Get a 6-step plan",
                                      animationDelay: 600,
                                    ),

                                    const Divider(height: 24, thickness: 0.5),

                                    // Step 3
                                    const WalkthroughStep(
                                      iconType: StepIconType.checkmark,
                                      text: "Master it",
                                      animationDelay: 750,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 36),

                              // Explanatory text
                              Text(
                                "Noshorts curates the best short videos into a guided path—so you don't have to.",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF9CA3AF),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(
                                duration: 600.ms,
                                curve: Curves.easeOut,
                                delay: 900.ms,
                              ),

                              // Add padding at the bottom to ensure content doesn't get cut off by button
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom fixed section with button and indicators
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Swipe indicator
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.swipe_right_alt,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Swipe to navigate',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Icon(
                                      Icons.swipe_left_alt,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ],
                                )
                                .animate(
                                  onPlay:
                                      (controller) =>
                                          controller.repeat(reverse: true),
                                )
                                .fadeIn(duration: 800.ms)
                                .then(delay: 800.ms)
                                .fadeOut(duration: 800.ms),
                          ),

                          const SizedBox(height: 12),

                          // Next button with direct implementation
                          GradientButton(
                            text: 'Next: See How It Works',
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              _navigateToNextScreen(context);
                            },
                          ),

                          const SizedBox(height: 12),

                          // Dot indicators
                          const Center(
                            child: DotIndicatorRow(
                              currentPage: 1,
                              pageCount: 3,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 1200.ms),
                        ],
                      ),
                    ),
                  ],
                ),

                // Left edge swipe indicator
                Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 2 - 60,
                  child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.swipe_right_alt,
                              color: Colors.black.withOpacity(0.3),
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate(
                        onPlay:
                            (controller) => controller.repeat(reverse: true),
                      )
                      .fadeIn(duration: 1000.ms)
                      .then()
                      .fadeOut(duration: 1000.ms),
                ),

                // Right edge swipe indicator
                Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.height / 2 - 60,
                  child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.swipe_left_alt,
                              color: Colors.black.withOpacity(0.3),
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate(
                        onPlay:
                            (controller) => controller.repeat(reverse: true),
                      )
                      .fadeIn(duration: 1000.ms)
                      .then()
                      .fadeOut(duration: 1000.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
      child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            curve: Curves.elasticOut,
          ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                const OnboardingScreen3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
