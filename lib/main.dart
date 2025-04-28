import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/core/theme/app_theme.dart';
import 'package:noshorts/models/category_data.dart';
import 'package:noshorts/screens/home/home_screen.dart';
import 'package:noshorts/services/premium_service.dart';
import 'package:noshorts/screens/onboarding/onboarding_screen_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed for now

// Add a global provider to track onboarding status
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

// Make it async to preload data
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables - keep for now, might be needed for other keys
  // await dotenv.load(fileName: '.env');
  // TODO: Uncomment dotenv loading if needed later

  // Initialize Supabase - Removed for now
  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL'] ?? '',
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  // );

  // Preload category data first since the entire app depends on it
  await CategoryData.initialize();

  // Initialize premium service after loading essential data
  await PremiumService.initialize();

  // Check if the user has completed onboarding
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    // Wrap the app with ProviderScope for Riverpod
    ProviderScope(
      overrides: [
        // Initialize the onboarding provider with the saved value
        onboardingCompletedProvider.overrideWith(
          (ref) => hasCompletedOnboarding,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Get Supabase client instance - Removed for now
// final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always go directly to home screen, skipping onboarding
    return MaterialApp(
      title: 'NoShorts',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(), // Always show home screen, bypassing onboarding
      debugShowCheckedModeBanner: false,
    );
  }
}
