import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:agir_vite/app/widgets/main_shell.dart';
import 'package:agir_vite/features/onboarding/screens/brand_screen.dart';
import 'package:agir_vite/features/shared/widgets/vite_video_theater_modal.dart';
import 'package:agir_vite/features/vite_guide/screens/en_urgence_screen.dart';

void main() {
  testWidgets('MainShell renders Accueil, Centres, Guide, Conseils and no Tension tab', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const SizedBox(key: Key('dashboard_view')),
            ),
            GoRoute(
              path: '/map',
              builder: (context, state) => const SizedBox(key: Key('map_view')),
            ),
            GoRoute(
              path: '/vite-guide',
              builder: (context, state) => const SizedBox(key: Key('guide_view')),
            ),
            GoRoute(
              path: '/stories',
              builder: (context, state) => const SizedBox(key: Key('stories_view')),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Centres'), findsOneWidget);
    expect(find.text('Guide'), findsOneWidget);
    expect(find.text('Conseils'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('Tension'), findsNothing);
  });

  testWidgets('EnUrgenceScreen renders without overflow on 360dp narrow screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnUrgenceScreen(onNext: () {}),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('E - En Urgence'), findsOneWidget);
    expect(find.text('Appelez immédiatement le SAMU (185)'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('BrandScreen fits entirely in 360x640 viewport without scrolling and shows Continuer CTA', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BrandScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('V.I.T.E'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

    // Ensure the 'Continuer' button is fully inside the 640px vertical viewport
    final buttonRect = tester.getRect(find.widgetWithText(ElevatedButton, 'Continuer'));
    expect(buttonRect.bottom, lessThanOrEqualTo(640.0));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('ViteVideoTheaterModal renders clean icon-only fullscreen without overflow and closes on tap', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = VideoPlayerController.asset('assets/videos/master_visage_v.mp4');
    addTearDown(() => controller.dispose());

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => ViteVideoTheaterModal(
                        controller: controller,
                        caption: 'Affaissement du visage',
                        isMuted: false,
                        onToggleMute: () {},
                      ),
                    );
                  },
                  child: const Text('Open Theater'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Theater'));
    await tester.pumpAndSettle();

    // Verify no text labels or SOS clutter are shown
    expect(find.text('Vue Cinéma'), findsNothing);
    expect(find.text('SOS'), findsNothing);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byKey(const Key('theater_close_button')), findsOneWidget);
    expect(find.byKey(const Key('theater_collapse_button')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('theater_close_button')));
    await tester.pumpAndSettle();

    expect(find.byType(ViteVideoTheaterModal), findsNothing);
  });
}
