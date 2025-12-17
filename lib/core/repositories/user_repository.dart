import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/local/boxes/hive_boxes.dart';
import '../models/user.dart';

abstract class IUserRepository {
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile?> getProfile();
}

class UserRepository implements IUserRepository {
  final Box<UserProfile> _box;

  UserRepository(this._box);

  static const String _keyUserProfile = 'user_profile';

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(_keyUserProfile, profile);
  }

  @override
  Future<UserProfile?> getProfile() async {
    return _box.get(_keyUserProfile);
  }
}

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  // Assuming HiveBoxes.user is opened in main.dart
  // If not, we might need to open it or use a simpler box for now
  return UserRepository(Hive.box<UserProfile>(HiveBoxes.user));
});
