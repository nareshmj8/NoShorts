import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/core/widgets/dot_indicator.dart';
import 'package:noshorts/core/widgets/google_button.dart';
import 'package:noshorts/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noshorts/main.dart';

class OnboardingScreen3 extends ConsumerStatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  ConsumerState<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends ConsumerState<OnboardingScreen3>
    with SingleTickerProviderStateMixin {
  late AnimationController _parallaxController;
  double _logoOffsetX = 0;
  double _logoOffsetY = 0;
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _parallaxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _parallaxController.dispose();
    super.dispose();
  }

  // Complete onboarding and navigate to home screen
  Future<void> _completeOnboarding() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      // Simulate sign-in delay (replace with actual sign-in logic later)
      await Future.delayed(const Duration(milliseconds: 1500));

      // Save onboarding completion status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      // Update the provider state
      ref.read(onboardingCompletedProvider.notifier).state = true;

      if (mounted) {
        // Navigate to home screen and replace the entire navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false, // This will remove all previous routes
        );
      }
    } catch (e) {
      // Handle sign-in error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: ${e.toString()}')),
        );
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe right to go back
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swiped from left to right
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: true, // Ensure safe area at bottom
          child: Stack(
            children: [
              // Main structure with fixed bottom section
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
                            // Back button only
                            Align(
                              alignment: Alignment.topLeft,
                              child: _buildBackButton(context),
                            ),

                            const SizedBox(height: 40),

                            // Logo with parallax effect - consistent size with other screens
                            GestureDetector(
                              // Add bounce effect on tap
                              onTap: () {
                                _animateLogoPress();
                                HapticFeedback.lightImpact();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Transform.translate(
                                  offset: Offset(_logoOffsetX, _logoOffsetY),
                                  child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 180,
                                        height: 180,
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
                                      .then(delay: 500.ms)
                                      .shimmer(duration: 1800.ms),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Headline
                            Text(
                              "Let's get started!",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(
                              duration: 600.ms,
                              curve: Curves.easeOut,
                              delay: 300.ms,
                            ),

                            const SizedBox(height: 20),

                            // Subtext
                            Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Text(
                                "Sign in to save your progress and pick your first topic.",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF6B7280),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ).animate().fadeIn(
                              duration: 600.ms,
                              curve: Curves.easeOut,
                              delay: 450.ms,
                            ),

                            const SizedBox(height: 48),

                            // Google Sign in Button with improved press animation
                            _isSigningIn
                                ? const CircularProgressIndicator()
                                : _AnimatedButton(
                                      onPressed: _completeOnboarding,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: GoogleButton(
                                          onPressed: () {}, // Handled by parent
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(
                                      duration: 600.ms,
                                      curve: Curves.easeOut,
                                      delay: 600.ms,
                                    )
                                    .moveY(begin: 20, end: 0),

                            // Add bottom padding to prevent content being cut off by fixed footer
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Fixed bottom section similar to other onboarding screens
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

                        // Progress dots
                        const Center(
                          child: DotIndicatorRow(currentPage: 2, pageCount: 3),
                        ).animate().fadeIn(duration: 400.ms, delay: 900.ms),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
      ),
    );
  }

  void _animateLogoPress() {
    // Apply a quick scale down and up animation to the logo
    _parallaxController.forward(from: 0).then((_) {
      _parallaxController.reverse();
    });
  }
}

class _AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _AnimatedButton({required this.child, required this.onPressed});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
