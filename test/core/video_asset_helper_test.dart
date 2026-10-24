import 'package:flutter_test/flutter_test.dart';
import 'package:agir_vite/core/utils/video_asset_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VideoAssetHelper', () {
    test('createAndInitialize throws for nonexistent asset', () async {
      expect(
        () => VideoAssetHelper.createAndInitialize('assets/videos/nonexistent.mp4'),
        throwsA(anything),
      );
    });
  });
}
