import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agir_vite/app/app.dart';
import 'package:agir_vite/features/onboarding/screens/intro_video_screen.dart';
import 'package:agir_vite/features/onboarding/screens/brand_screen.dart';

void main() {
  testWidgets('App starts at Intro Video Screen and skips to Brand Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AgirViteApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that Intro Video Screen is displayed with 'Passer la vidéo' button
    expect(find.byType(IntroVideoScreen), findsOneWidget);
    expect(find.text('Passer la vidéo'), findsOneWidget);

    // Tap 'Passer la vidéo' to skip to BrandScreen
    await tester.tap(find.text('Passer la vidéo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));

    // Verify that Brand Screen is now displayed with top institutional logos
    expect(find.byType(BrandScreen), findsOneWidget);
    expect(find.byKey(const Key('brand_ministry_logo')), findsOneWidget);
    expect(find.byKey(const Key('brand_pnlmm_logo')), findsOneWidget);
    expect(find.text('V.I.T.E'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    
    // Unmount the widget to dispose the infinite animation and cancel timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
