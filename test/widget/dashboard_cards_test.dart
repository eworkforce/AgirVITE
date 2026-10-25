import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/features/dashboard/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard renders stylized two-tier title and V, I, T, E letter boxes with image assets', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify stylized header elements are rendered
    expect(find.text('CHAQUE MINUTE COMPTE'), findsOneWidget);
    expect(find.text("Comprendre les signes d'alerte"), findsOneWidget);
    expect(find.text("Les 4 Signes d'Urgence"), findsNothing);

    // Verify all 4 letters are rendered
    expect(find.text('V'), findsOneWidget);
    expect(find.text('I'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
    expect(find.text('E'), findsOneWidget);

    // Verify the 4 images are used as Image widgets
    final images = tester.widgetList<Image>(find.byType(Image));
    final assetNames = images
        .map((img) => img.image)
        .whereType<AssetImage>()
        .map((asset) => asset.assetName)
        .toList();

    expect(assetNames.contains('assets/images/GuideVite1.jpeg'), isTrue);
    expect(assetNames.contains('assets/images/incapacite_arm_ci.jpg'), isTrue);
    expect(assetNames.contains('assets/images/trouble_parole_ci.jpg'), isTrue);
    expect(assetNames.contains('assets/images/Centre1.jpeg'), isTrue);

    // Clean up
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
