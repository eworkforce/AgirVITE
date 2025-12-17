import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/onboarding/screens/brand_screen.dart';
import '../features/onboarding/screens/pledge_screen.dart';
import '../features/onboarding/screens/reflex_drill_screen.dart';
import '../features/onboarding/screens/profile_setup_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/vite_guide/screens/vite_guide_screen.dart';
import '../features/bp_tracker/screens/capture_screen.dart';
import '../features/bp_tracker/screens/review_screen.dart';
import '../features/stories/screens/stories_feed_screen.dart';
import '../features/map/screens/map_screen.dart';
import '../features/profile/screens/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingControllerProvider);
  
  return GoRouter(
    initialLocation: '/onboarding/brand',
    redirect: (context, state) {
      // While loading onboarding status, we don't redirect yet
      if (onboardingState.isLoading) return null;

      final isComplete = onboardingState.valueOrNull ?? false;
      final isGoingToOnboarding = state.matchedLocation.startsWith('/onboarding');
      
      // LOGIC CHANGE:
      // Even if onboarding is complete (isComplete == true), we do NOT force redirect to dashboard.
      // We ALWAYS allow the user to see the initial screen ('/onboarding/brand') if that's where they are starting.
      // The "Brand Screen" is effectively the Splash/Welcome screen.
      
      // Only redirect IF we are trying to access a protected route (like /dashboard) 
      // AND we haven't finished onboarding.
      if (!isComplete && !isGoingToOnboarding) {
        return '/onboarding/brand';
      }

      // If we are fully onboarded, we generally want to let the user stay on the landing page
      // until they explicitly tap "Continuer". 
      // However, if the App reloads, GoRouter might try to restore the last route.
      // 
      // If the requirement is "Always start at Brand Screen", we should simply REMOVE the 
      // redirect that pushes them to dashboard.

      // REMOVED: The block that auto-redirects to dashboard if isComplete is true.
      
      return null;
    },
    routes: [
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
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/vite-guide',
        builder: (context, state) => const ViteGuideScreen(),
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
  );
});
