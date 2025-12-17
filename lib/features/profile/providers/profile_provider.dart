import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agir_vite/core/models/user.dart';
import 'package:agir_vite/core/repositories/user_repository.dart';

// Provider to fetch the user profile (async)
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return ref.read(userRepositoryProvider).getProfile();
});
