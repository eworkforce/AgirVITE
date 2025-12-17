import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/onboarding_repository.dart';

final onboardingControllerProvider = AsyncNotifierProvider<OnboardingController, bool>(() {
  return OnboardingController();
});

class OnboardingController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final repository = ref.watch(onboardingRepositoryProvider);
    return repository.isOnboardingComplete();
  }

  Future<void> completeOnboarding() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(onboardingRepositoryProvider);
      await repository.setOnboardingComplete();
      return true;
    });
  }
}
