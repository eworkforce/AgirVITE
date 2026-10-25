import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/features/stories/screens/stories_feed_screen.dart';

void main() {
  testWidgets(
    'StoriesFeedScreen renders Recto/Verso flip cards, flips on tap, and switches decks',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StoriesFeedScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the 2 deck toggles and initial card (Recto)
      expect(find.text('Les 6 Dangers'), findsOneWidget);
      expect(find.text('Les 6 Bons Réflexes'), findsOneWidget);
      expect(find.text('La Tension Élevée (HTA)'), findsOneWidget);
      expect(find.text('Impliquée dans près de 8 AVC sur 10'), findsOneWidget);

      // Tap the first card to flip from Recto to Verso
      await tester.tap(find.byKey(const Key('flip_card_danger_hta')));
      await tester.pumpAndSettle();

      // Verify Verso content is now displayed
      expect(find.text('VERSO'), findsOneWidget);
      expect(find.text('Pourquoi c’est dangereux ?'), findsOneWidget);
      expect(find.text('Le bon réflexe'), findsOneWidget);

      // Tap again to flip back to Recto
      await tester.tap(find.byKey(const Key('flip_card_danger_hta')));
      await tester.pumpAndSettle();
      expect(find.text('Impliquée dans près de 8 AVC sur 10'), findsOneWidget);

      // Switch to 'Les 6 Bons Réflexes' deck
      await tester.tap(find.byKey(const Key('deck_toggle_reflexes')));
      await tester.pumpAndSettle();
      expect(find.text('Connaître mes Chiffres'), findsOneWidget);
      expect(find.text('Objectif Tension : moins de 14 / 9'), findsOneWidget);
    },
  );
}
