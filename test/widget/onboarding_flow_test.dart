import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/app/app.dart';
import 'package:agir_vite/core/repositories/onboarding_repository.dart';
import 'package:agir_vite/features/dashboard/screens/dashboard_screen.dart';
import 'package:agir_vite/features/onboarding/screens/brand_screen.dart';
import 'package:agir_vite/features/onboarding/screens/pledge_screen.dart';
import 'package:agir_vite/features/onboarding/screens/reflex_drill_screen.dart';

// Fake Repository
class FakeOnboardingRepository implements IOnboardingRepository {
  bool _isComplete = false;

  @override
  Future<bool> isOnboardingComplete() async => _isComplete;

  @override
  Future<void> setOnboardingComplete() async {
    _isComplete = true;
  }
}

void main() {
  testWidgets('Full Onboarding Flow Test', (WidgetTester tester) async {
    final fakeRepository = FakeOnboardingRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const AgirViteApp(),
      ),
    );

    // 1. Initial State: Brand Screen
    // Infinite animation on BrandScreen prevents pumpAndSettle from returning.
    // We pump for a short duration to let the widget build and animation start.
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BrandScreen), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);

    // 2. Navigate to Pledge Screen
    await tester.tap(find.text('Continuer'));
    // Once we navigate away, the infinite animation is disposed, so pumpAndSettle should work.
    await tester.pumpAndSettle();
    expect(find.byType(PledgeScreen), findsOneWidget);
    expect(find.text("Contre l'AVC,"), findsOneWidget);

    // 3. Navigate to Reflex Drill Screen
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.byType(ReflexDrillScreen), findsOneWidget);
    expect(find.text("Le Réflexe V.I.T.E."), findsOneWidget);

    // 4. Perform Reflex Drill (Long Press)
    final sosButton = find.byType(GestureDetector).first; // Needs specific finder usually, but here it's the main interaction
    // Or find by text inside the button or specific key if added. 
    // The button has a child Stack with "SOS" text.
    final sosFinder = find.text('SOS');
    
    // Press and hold for 2.1 seconds (slightly more than required 2s)
    await tester.press(sosFinder);
    await tester.pump(const Duration(milliseconds: 1000)); // Halfway
    await tester.pump(const Duration(milliseconds: 1100)); // Complete
    await tester.pumpAndSettle(); // Wait for navigation
    // We also need to release the gesture in reality, but tester.pressDown / press might be better if we want fine control.
    // tester.press does a down and up sequence but usually short.
    // We need tester.longPress or manual down/pause/up.
  });
  
  testWidgets('Reflex Drill Success Logic', (WidgetTester tester) async {
      final fakeRepository = FakeOnboardingRepository();
  
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: const AgirViteApp(),
        ),
      );
      
      // Fast forward to Reflex Screen
      await tester.pump(const Duration(seconds: 1)); // Brand (avoid pumpAndSettle due to infinite anim)
      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle(); // Pledge
      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle(); // Reflex
  
      // Execute Long Press
      final gesture = await tester.startGesture(tester.getCenter(find.text('SOS')));
      
      // Pump frames to simulate time passing and progress updating
      for (int i = 0; i < 45; i++) { // 45 * 50ms = 2250ms > 2000ms
        await tester.pump(const Duration(milliseconds: 50));
      }
      
      await gesture.up();
      await tester.pumpAndSettle();
  
      // Should be on Dashboard now
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(await fakeRepository.isOnboardingComplete(), isTrue);
    });
}
