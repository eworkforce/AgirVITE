import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/onboarding/screens/intro_video_screen.dart';
import '../features/onboarding/screens/brand_screen.dart';
import '../features/onboarding/screens/pledge_screen.dart';
import '../features/onboarding/screens/reflex_drill_screen.dart';
import '../features/onboarding/screens/profile_setup_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/vite_guide/screens/vite_guide_screen.dart';
import '../features/bp_tracker/screens/capture_screen.dart';
import '../features/bp_tracker/screens/review_screen.dart';
import '../features/bp_tracker/screens/bp_hub_screen.dart';
import '../features/stories/screens/stories_feed_screen.dart';
import '../features/map/screens/map_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import 'widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingControllerProvider);
  
  return GoRouter(
    initialLocation: '/onboarding/intro-video',
    redirect: (context, state) {
      // While loading onboarding status, we don't redirect yet
      if (onboardingState.isLoading) return null;

      final isComplete = onboardingState.valueOrNull ?? false;
      final isGoingToOnboarding = state.matchedLocation.startsWith('/onboarding');
      
      // LOGIC:
      // Even if onboarding is complete (isComplete == true), we do NOT force redirect to dashboard.
      // We allow the user to see the intro video / welcome screen if that's where they are starting.
      // Only redirect IF we are trying to access a protected route (like /dashboard) 
      // AND we haven't finished onboarding.
      if (!isComplete && !isGoingToOnboarding) {
        return '/onboarding/intro-video';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding/intro-video',
        builder: (context, state) => const IntroVideoScreen(),
      ),
      GoRoute(
        path: '/onboarding/brand',
        builder: (context, state) => const BrandScreen(),
      ),
      GoRoute(
        path: '/onboarding/pledge',
        builder: (context, state) => const PledgeScreen(),
      ),
      GoRoute(
        path: '/onboarding/reflex',
        builder: (context, state) => const ReflexDrillScreen(),
      ),
      GoRoute(
        path: '/onboarding/profile',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      // Main shell wrapped routes
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vite-guide',
            builder: (context, state) {
              final initialIndex = state.extra as int? ?? 0;
              return ViteGuideScreen(initialIndex: initialIndex);
            },
          ),
          GoRoute(
            path: '/bp-tracker',
            builder: (context, state) => const BPHubScreen(),
          ),
          GoRoute(
            path: '/bp-tracker/capture',
            builder: (context, state) => const CaptureScreen(),
          ),
          GoRoute(
            path: '/bp-tracker/review',
            builder: (context, state) {
              final extra = state.extra as Map<String, int>;
              return ReviewScreen(extractedData: extra);
            },
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: '/stories',
            builder: (context, state) => const StoriesFeedScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
