import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/app/app.dart';
import 'package:agir_vite/core/repositories/onboarding_repository.dart';
import 'package:agir_vite/features/onboarding/screens/intro_video_screen.dart';
import 'package:agir_vite/features/onboarding/screens/brand_screen.dart';
import 'package:agir_vite/features/onboarding/screens/pledge_screen.dart';
import 'package:agir_vite/features/onboarding/screens/reflex_drill_screen.dart';
import 'package:agir_vite/features/onboarding/screens/profile_setup_screen.dart';

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
  testWidgets('Full Onboarding Flow Test with Step Progress Indicator and Back Navigation', (WidgetTester tester) async {
    final fakeRepository = FakeOnboardingRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const AgirViteApp(),
      ),
    );

    // 1. Initial State: Intro Video Screen
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(IntroVideoScreen), findsOneWidget);
    expect(find.text('Passer la vidéo'), findsOneWidget);

    // 2. Skip Intro Video to Brand Screen
    await tester.tap(find.text('Passer la vidéo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(BrandScreen), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);

    // 3. Navigate to Pledge Screen (Step 1 of 3)
    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(PledgeScreen), findsOneWidget);
    expect(find.text('Étape 1 sur 3'), findsOneWidget);

    // 4. Navigate to Reflex Screen (Step 2 of 3)
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.byType(ReflexDrillScreen), findsOneWidget);
    expect(find.text('Étape 2 sur 3'), findsOneWidget);

    // Test Back Button from Step 2 back to Step 1
    await tester.tap(find.byKey(const Key('onboarding_back_button')));
    await tester.pumpAndSettle();
    expect(find.byType(PledgeScreen), findsOneWidget);
    expect(find.text('Étape 1 sur 3'), findsOneWidget);
  });

  testWidgets('Reflex Drill Success Logic and Profile Setup Contact Terminology', (WidgetTester tester) async {
    final fakeRepository = FakeOnboardingRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const AgirViteApp(),
      ),
    );

    // Skip Intro Video
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Passer la vidéo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2)); // Brand Screen

    // Navigate to Pledge
    await tester.ensureVisible(find.text('Continuer'));
    await tester.tap(find.text('Continuer'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(); // Pledge

    // Navigate to Reflex
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle(); // Reflex

    // Execute Long Press on SOS
    final gesture = await tester.startGesture(tester.getCenter(find.text('SOS')));

    // Pump frames to simulate time passing and progress updating
    for (int i = 0; i < 45; i++) {
      // 45 * 50ms = 2250ms > 2000ms
      await tester.pump(const Duration(milliseconds: 50));
    }

    await gesture.up();
    await tester.pumpAndSettle();

    // Should be on Profile Setup Screen now (Step 3 of 3)
    expect(find.byType(ProfileSetupScreen), findsOneWidget);
    expect(find.text('Étape 3 sur 3'), findsOneWidget);
    expect(find.text("Ajoutez votre premier contact d'urgence"), findsOneWidget);
    expect(find.text('Nom du contact'), findsOneWidget);
    expect(find.textContaining('Gardien'), findsNothing);
    expect(await fakeRepository.isOnboardingComplete(), isFalse);
  });

  testWidgets('ProfileSetupScreen does not overflow when soft keyboard is open', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 420));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileSetupScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Étape 3 sur 3'), findsOneWidget);
    expect(find.text("Ajoutez votre premier contact d'urgence"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
