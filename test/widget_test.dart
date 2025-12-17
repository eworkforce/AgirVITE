// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agir_vite/app/app.dart';

void main() {
  testWidgets('App starts at Brand Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AgirViteApp(),
      ),
    );
    // Pump for a short duration to let animations start but don't wait for them to finish (infinite)
    await tester.pump(const Duration(seconds: 1));

    // Verify that the Brand Screen is displayed.
    expect(find.text('AVC\nESPOIR'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    
    // Unmount the widget to dispose the infinite animation and cancel timers
    await tester.pumpWidget(const SizedBox());
  });
}
