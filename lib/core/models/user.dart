import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserProfile with _$UserProfile {
  @HiveType(typeId: 2) // Using ID 2, assuming 0 is BPReading or similar
  const factory UserProfile({
    @HiveField(0) required String id,
    @HiveField(1) required String displayName,
    @HiveField(2) String? phoneNumber,
    @HiveField(3) required DateTime createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
