import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/core/theme/app_theme.dart';
import 'package:noshorts/core/widgets/gradient_button.dart';
import 'package:noshorts/providers/premium_provider.dart';
import 'package:noshorts/screens/premium/widgets/benefit_card.dart';
import 'package:noshorts/screens/premium/widgets/pricing_card.dart';
import 'package:noshorts/screens/home/components/home_bottom_navigation.dart';
import 'package:noshorts/screens/my_plans/my_plans_screen.dart';
import 'package:noshorts/screens/settings/settings_screen.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPlan = 'yearly'; // Default selected plan
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final premiumState = ref.watch(premiumProvider);
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    // Get screen size for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isLandscape = screenSize.width > screenSize.height;

    // Calculate adaptive values
    final double horizontalPadding = isTablet ? 32.0 : 20.0;
    final bool useHorizontalLayout = isTablet && isLandscape;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child:
                  useHorizontalLayout
                      // Two-column layout for landscape tablets
                      ? _buildTabletLayout(premiumState, isDarkMode)
                      // Standard vertical layout for phones and portrait tablets
                      : _buildPhoneLayout(premiumState, isDarkMode),
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 2, // Set to Premium tab
        onTap: (index) {
          if (index != 2) {
            // If tapping the Explore tab (0), simply go back to home screen
            if (index == 0) {
              Navigator.pop(context); // Just go back without parameters
            } else {
              // For other tabs (My Plans or Settings), navigate directly
              // without going back to home first
              if (index == 1) {
                // Navigate to My Plans
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const MyPlansScreen()),
                );
              } else if (index == 3) {
                // Navigate to Settings
                Navigator.pushReplacement(
                  context,
                  _createTabRoute(const SettingsScreen()),
                );
              }
            }
          }
        },
        pulseController: _animationController,
        pulseAnimation: _fadeAnimation,
      ),
    );
  }

  // New method for phone layout (vertical)
  Widget _buildPhoneLayout(PremiumState premiumState, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Benefits heading
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Premium Benefits',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),

        // Benefits section - Card with subtle elevation
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: _buildCompactBenefitsList(),
        ),

        const SizedBox(height: 24),

        // Show current subscription if premium
        if (premiumState.isPremium) _buildCurrentSubscription(premiumState),

        // Pricing Options (only show if not premium)
        if (!premiumState.isPremium) ...[
          // Section title for pricing
          Text(
            'Choose Your Plan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Pricing options
          Expanded(child: _buildPricingOptions(false)),

          // Upgrade button and trial notice
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                _buildUpgradeButton(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '7-day free trial, cancel anytime',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // New method for tablet layout (horizontal)
  Widget _buildTabletLayout(PremiumState premiumState, bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Benefits section
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Benefits',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Benefits section with extended information
                      Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTabletBenefitsList(),
                            const SizedBox(height: 24),

                            // Simple premium image instead of complex container decoration
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 180,
                                width: double.infinity,
                                color: const Color(0xFFF0E6FF),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium,
                                      size: 48,
                                      color: Color(0xFF7209B7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Premium Experience',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF7209B7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.0,
                                      ),
                                      child: Text(
                                        'Unlock your full potential',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF7209B7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Show current subscription if premium
                      if (premiumState.isPremium) ...[
                        const SizedBox(height: 24),
                        _buildCurrentSubscription(premiumState),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Right column: Subscription options
            if (!premiumState.isPremium)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Plan',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pricing options in horizontal layout for tablets
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildPricingOptions(true),
                        ),
                      ),

                      // Upgrade button and trial notice
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildUpgradeButton(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '7-day free trial, cancel anytime',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color:
                                        isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildUpgradeButton() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;

    return TextButton(
      onPressed: () => _upgradeToPremium(),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 30 : 25),
        ),
        backgroundColor: const Color(0xFF7209B7),
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 12,
          horizontal: isTablet ? 32 : 24,
        ),
        minimumSize: Size(double.infinity, isTablet ? 60 : 50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Upgrade Now',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 18 : 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscription(PremiumState premiumState) {
    final expiryDate = premiumState.expiryDate;
    final formattedDate =
        expiryDate != null
            ? '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}'
            : 'Unknown';

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Active Subscription',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: isTablet ? 18 : null,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          _buildSubscriptionDetail(
            Icons.assignment,
            'Type: ${premiumState.subscriptionType ?? 'Unknown'}',
          ),
          const SizedBox(height: 4),
          _buildSubscriptionDetail(
            Icons.calendar_today,
            'Expires: $formattedDate',
          ),
          SizedBox(height: isTablet ? 16 : 12),
          ElevatedButton.icon(
            onPressed: () => _cancelSubscription(),
            icon: const Icon(Icons.cancel, color: Colors.white, size: 16),
            label: const Text('Cancel Subscription'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetail(IconData icon, String text) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;

    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: isTablet ? 16 : 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 14 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactBenefitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BenefitCard(
          title: 'Take Action to Your Hobbies',
          subtitle: 'Turn interests into practical learning activities',
        ),
        BenefitCard(
          title: 'Unlimited Plans',
          subtitle: 'Save as many learning plans as you need',
        ),
        BenefitCard(
          title: 'Access to 1000+ Topics',
          subtitle: 'Explore a vast library of premium learning content',
        ),
      ],
    );
  }

  // Extended benefit list with additional details for tablets
  Widget _buildTabletBenefitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BenefitCard(
          title: 'Take Action to Your Hobbies',
          subtitle:
              'Turn interests into practical learning activities with guided steps',
        ),
        SizedBox(height: 8),
        BenefitCard(
          title: 'Unlimited Plans',
          subtitle:
              'Save as many learning plans as you need with unlimited storage',
        ),
        SizedBox(height: 8),
        BenefitCard(
          title: 'Access to 1000+ Topics',
          subtitle:
              'Explore a vast library of premium learning content curated by experts',
        ),
        SizedBox(height: 8),
        BenefitCard(
          title: 'Priority Support',
          subtitle: 'Get help when you need it with our dedicated support team',
        ),
      ],
    );
  }

  Widget _buildPricingOptions(bool isTabletLayout) {
    // For tablets in landscape, arrange the pricing cards horizontally
    if (isTabletLayout) {
      return Column(
        children: [
          _buildTabletPricingCard(
            title: 'Weekly',
            price: '\$1.49',
            period: 'week',
            isSelected: _selectedPlan == 'weekly',
            onTap: () {
              setState(() {
                _selectedPlan = 'weekly';
              });
            },
            isPopular: false,
          ),
          const SizedBox(height: 16),
          _buildTabletPricingCard(
            title: 'Monthly',
            price: '\$3.99',
            period: 'month',
            isSelected: _selectedPlan == 'monthly',
            onTap: () {
              setState(() {
                _selectedPlan = 'monthly';
              });
            },
            isPopular: false,
          ),
          const SizedBox(height: 16),
          _buildTabletPricingCard(
            title: 'Yearly',
            price: '\$33.59',
            period: 'year',
            originalPrice: '\$48.00',
            savePercentage: 30,
            isSelected: _selectedPlan == 'yearly',
            onTap: () {
              setState(() {
                _selectedPlan = 'yearly';
              });
            },
            isPopular: true,
          ),
        ],
      );
    }

    // For mobile or portrait view, use the vertical list
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        PricingCard(
          title: 'Weekly',
          price: '\$1.49',
          period: 'week',
          isSelected: _selectedPlan == 'weekly',
          onTap: () {
            setState(() {
              _selectedPlan = 'weekly';
            });
          },
          isPopular: false,
        ),
        PricingCard(
          title: 'Monthly',
          price: '\$3.99',
          period: 'month',
          isSelected: _selectedPlan == 'monthly',
          onTap: () {
            setState(() {
              _selectedPlan = 'monthly';
            });
          },
          isPopular: false,
        ),
        PricingCard(
          title: 'Yearly',
          price: '\$33.59',
          period: 'year',
          originalPrice: '\$48.00',
          savePercentage: 30,
          isSelected: _selectedPlan == 'yearly',
          onTap: () {
            setState(() {
              _selectedPlan = 'yearly';
            });
          },
          isPopular: true,
        ),
      ],
    );
  }

  // Custom pricing card for tablet layout
  Widget _buildTabletPricingCard({
    required String title,
    required String price,
    required String period,
    String? originalPrice,
    int? savePercentage,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isPopular,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF7209B7)
                    : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF7209B7).withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Stack(
          children: [
            // Popular badge
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4361EE),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radio button
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF7209B7)
                                : Colors.grey.withOpacity(0.5),
                        width: 2,
                      ),
                      color: isSelected ? const Color(0xFF7209B7) : bgColor,
                    ),
                    child:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                            : null,
                  ),

                  const SizedBox(height: 16),

                  // Plan title
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  // Billing period
                  Text(
                    period == 'year'
                        ? 'Billed annually'
                        : 'Billed $period' + 'ly',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price
                  Text(
                    price,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? const Color(0xFF7209B7) : Colors.black87,
                    ),
                  ),

                  // Original price and savings
                  if (originalPrice != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          originalPrice,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7209B7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            savePercentage != null
                                ? 'SAVE ${savePercentage}%'
                                : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Monthly equivalent for yearly plan
                  if (period == 'year') ...[
                    const SizedBox(height: 4),
                    Text(
                      '\$${(double.parse(price.substring(1)) / 12).toStringAsFixed(2)}/month',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _upgradeToPremium() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing your subscription...'),
              ],
            ),
          ),
    );

    try {
      // Call provider to upgrade
      await ref.read(premiumProvider.notifier).upgradeToPremium(_selectedPlan);

      // Close loading indicator
      if (mounted) Navigator.pop(context);

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Success'),
                content: Text(
                  'You are now subscribed to the $_selectedPlan plan!',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      // Close loading indicator
      if (mounted) Navigator.pop(context);

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to process subscription: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  void _cancelSubscription() async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Subscription'),
            content: const Text(
              'Are you sure you want to cancel your subscription? You will lose access to premium features at the end of your billing period.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No, Keep It'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => const AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cancelling subscription...'),
                            ],
                          ),
                        ),
                  );

                  try {
                    // Call provider to cancel
                    await ref
                        .read(premiumProvider.notifier)
                        .cancelSubscription();

                    // Close loading indicator
                    if (mounted) Navigator.pop(context);

                    // Show success dialog
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text(
                                'Your subscription has been cancelled. You will have access to premium features until the end of your current billing period.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                  } catch (e) {
                    // Close loading indicator
                    if (mounted) Navigator.pop(context);

                    // Show error dialog
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(
                                'Failed to cancel subscription: $e',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  Route _createTabRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
