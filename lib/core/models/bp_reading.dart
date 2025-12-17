import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'bp_reading.freezed.dart';
part 'bp_reading.g.dart';

@freezed
class BPReading with _$BPReading {
  @HiveType(typeId: 0)
  const factory BPReading({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime timestamp,
    @HiveField(2) required int systolic,
    @HiveField(3) required int diastolic,
    @HiveField(4) required int pulse,
    @HiveField(5) @Default(false) bool isManual,
    @HiveField(6) String? notes,
  }) = _BPReading;

  factory BPReading.fromJson(Map<String, dynamic> json) => _$BPReadingFromJson(json);
}
