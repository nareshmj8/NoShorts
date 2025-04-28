import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/core/widgets/dot_indicator.dart';
import 'package:noshorts/core/widgets/gradient_button.dart';
import 'package:noshorts/screens/onboarding/onboarding_screen_2.dart';
import 'package:noshorts/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noshorts/main.dart';

class OnboardingScreen1 extends ConsumerWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      // Swipe left to go to next screen
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swiped from right to left
          HapticFeedback.lightImpact();
          _navigateToNextScreen(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: true, // Ensure safe area at bottom
          child: Column(
            children: [
              // Main content in scrollview
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        // Spacer to push content down a bit
                        const SizedBox(height: 48),

                        // Logo in the center with shadow
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
                            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                            ),

                        const SizedBox(height: 48),

                        // Title "Welcome to Noshorts"
                        Text(
                          'Welcome to NoShorts',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                          duration: 600.ms,
                          curve: Curves.easeOut,
                          delay: 300.ms,
                        ),

                        const SizedBox(height: 16),

                        // Tagline
                        Text(
                          'Learn smarter, not harder.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                          duration: 600.ms,
                          curve: Curves.easeOut,
                          delay: 450.ms,
                        ),

                        // Swipe indicator
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Swipe to navigate',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
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
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom fixed section containing button and indicators
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Get Started Button - direct implementation
                    GradientButton(
                      text: 'Get Started',
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _navigateToNextScreen(context);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Dot indicators
                    const DotIndicatorRow(
                      currentPage: 0,
                      pageCount: 3,
                    ).animate().fadeIn(duration: 400.ms, delay: 750.ms),

                    const SizedBox(height: 20),

                    // Skip intro link (larger text)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _skipOnboarding(context, ref);
                      },
                      child: Text(
                        'Skip intro',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 14),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 900.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                const OnboardingScreen2(),
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

  // Skip onboarding and go directly to home screen
  Future<void> _skipOnboarding(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Save onboarding completion status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      // Update the provider state
      ref.read(onboardingCompletedProvider.notifier).state = true;

      // Close loading indicator
      Navigator.pop(context);

      // Navigate to home screen and replace the entire navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // This will remove all previous routes
      );
    } catch (e) {
      // Close loading indicator if open
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
