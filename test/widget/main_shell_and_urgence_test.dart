import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agir_vite/app/widgets/main_shell.dart';
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
}
