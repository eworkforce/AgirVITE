import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/onboarding/screens/brand_screen.dart';
import '../features/onboarding/screens/pledge_screen.dart';
import '../features/onboarding/screens/reflex_drill_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/vite_guide/screens/vite_guide_screen.dart';
import '../features/bp_tracker/screens/capture_screen.dart';
import '../features/bp_tracker/screens/review_screen.dart';
import '../features/stories/screens/stories_feed_screen.dart';
import '../features/map/screens/centers_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingControllerProvider);
  
  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      // While loading onboarding status, we don't redirect yet
      if (onboardingState.isLoading) return null;

      final isComplete = onboardingState.valueOrNull ?? false;
      final isGoingToOnboarding = state.matchedLocation.startsWith('/onboarding');

      // If not complete and not in onboarding, go to onboarding
      if (!isComplete && !isGoingToOnboarding) {
        return '/onboarding/brand';
      }

      // If complete and trying to access onboarding, go to dashboard
      // (Optional: allow revisiting onboarding via settings later, but for now block it)
      if (isComplete && isGoingToOnboarding) {
        return '/dashboard';
      }

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
        builder: (context, state) => const CentersListScreen(),
      ),
      GoRoute(
        path: '/stories',
        builder: (context, state) => const StoriesFeedScreen(),
      ),
    ],
  );
});
