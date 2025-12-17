import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'stroke_center.freezed.dart';
part 'stroke_center.g.dart';

@freezed
class StrokeCenter with _$StrokeCenter {
  @HiveType(typeId: 1)
  const factory StrokeCenter({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String address,
    @HiveField(3) required double latitude,
    @HiveField(4) required double longitude,
    @HiveField(5) required String phone,
    @HiveField(6) @Default(false) bool hasScanner,
    @HiveField(7) @Default(true) bool isOpen247,
  }) = _StrokeCenter;

  factory StrokeCenter.fromJson(Map<String, dynamic> json) => _$StrokeCenterFromJson(json);
}
