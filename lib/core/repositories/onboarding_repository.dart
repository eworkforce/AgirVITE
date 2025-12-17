import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/local/boxes/hive_boxes.dart';

abstract class IOnboardingRepository {
  Future<bool> isOnboardingComplete();
  Future<void> setOnboardingComplete();
}

class OnboardingRepository implements IOnboardingRepository {
  final Box _box;

  OnboardingRepository(this._box);

  static const String _keyOnboardingComplete = 'onboarding_complete';

  @override
  Future<bool> isOnboardingComplete() async {
    return _box.get(_keyOnboardingComplete, defaultValue: false);
  }

  @override
  Future<void> setOnboardingComplete() async {
    await _box.put(_keyOnboardingComplete, true);
  }
}

final onboardingRepositoryProvider = Provider<IOnboardingRepository>((ref) {
  // We assume the box is opened in main.dart or via an async provider.
  // For simplicity in this phase, we'll use Hive.box directly but normally we'd await it.
  // Better approach: have a FutureProvider for the box, or ensure it's open.
  // Let's use Hive.box assuming it's opened in main.dart initialization sequence.
  return OnboardingRepository(Hive.box(HiveBoxes.settings));
});
