// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bp_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BPReading _$BPReadingFromJson(Map<String, dynamic> json) {
  return _BPReading.fromJson(json);
}

/// @nodoc
mixin _$BPReading {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get timestamp => throw _privateConstructorUsedError;
  @HiveField(2)
  int get systolic => throw _privateConstructorUsedError;
  @HiveField(3)
  int get diastolic => throw _privateConstructorUsedError;
  @HiveField(4)
  int get pulse => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isManual => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BPReadingCopyWith<BPReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BPReadingCopyWith<$Res> {
  factory $BPReadingCopyWith(BPReading value, $Res Function(BPReading) then) =
      _$BPReadingCopyWithImpl<$Res, BPReading>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime timestamp,
      @HiveField(2) int systolic,
      @HiveField(3) int diastolic,
      @HiveField(4) int pulse,
      @HiveField(5) bool isManual,
      @HiveField(6) String? notes});
}

/// @nodoc
class _$BPReadingCopyWithImpl<$Res, $Val extends BPReading>
    implements $BPReadingCopyWith<$Res> {
  _$BPReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? pulse = null,
    Object? isManual = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      systolic: null == systolic
          ? _value.systolic
          : systolic // ignore: cast_nullable_to_non_nullable
              as int,
      diastolic: null == diastolic
          ? _value.diastolic
          : diastolic // ignore: cast_nullable_to_non_nullable
              as int,
      pulse: null == pulse
          ? _value.pulse
          : pulse // ignore: cast_nullable_to_non_nullable
              as int,
      isManual: null == isManual
          ? _value.isManual
          : isManual // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BPReadingImplCopyWith<$Res>
    implements $BPReadingCopyWith<$Res> {
  factory _$$BPReadingImplCopyWith(
          _$BPReadingImpl value, $Res Function(_$BPReadingImpl) then) =
      __$$BPReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime timestamp,
      @HiveField(2) int systolic,
      @HiveField(3) int diastolic,
      @HiveField(4) int pulse,
      @HiveField(5) bool isManual,
      @HiveField(6) String? notes});
}

/// @nodoc
class __$$BPReadingImplCopyWithImpl<$Res>
    extends _$BPReadingCopyWithImpl<$Res, _$BPReadingImpl>
    implements _$$BPReadingImplCopyWith<$Res> {
  __$$BPReadingImplCopyWithImpl(
      _$BPReadingImpl _value, $Res Function(_$BPReadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? pulse = null,
    Object? isManual = null,
    Object? notes = freezed,
  }) {
    return _then(_$BPReadingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      systolic: null == systolic
          ? _value.systolic
          : systolic // ignore: cast_nullable_to_non_nullable
              as int,
      diastolic: null == diastolic
          ? _value.diastolic
          : diastolic // ignore: cast_nullable_to_non_nullable
              as int,
      pulse: null == pulse
          ? _value.pulse
          : pulse // ignore: cast_nullable_to_non_nullable
              as int,
      isManual: null == isManual
          ? _value.isManual
          : isManual // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0)
class _$BPReadingImpl implements _BPReading {
  const _$BPReadingImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.timestamp,
      @HiveField(2) required this.systolic,
      @HiveField(3) required this.diastolic,
      @HiveField(4) required this.pulse,
      @HiveField(5) this.isManual = false,
      @HiveField(6) this.notes});

  factory _$BPReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BPReadingImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final DateTime timestamp;
  @override
  @HiveField(2)
  final int systolic;
  @override
  @HiveField(3)
  final int diastolic;
  @override
  @HiveField(4)
  final int pulse;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isManual;
  @override
  @HiveField(6)
  final String? notes;

  @override
  String toString() {
    return 'BPReading(id: $id, timestamp: $timestamp, systolic: $systolic, diastolic: $diastolic, pulse: $pulse, isManual: $isManual, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BPReadingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.systolic, systolic) ||
                other.systolic == systolic) &&
            (identical(other.diastolic, diastolic) ||
                other.diastolic == diastolic) &&
            (identical(other.pulse, pulse) || other.pulse == pulse) &&
            (identical(other.isManual, isManual) ||
                other.isManual == isManual) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, timestamp, systolic, diastolic, pulse, isManual, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BPReadingImplCopyWith<_$BPReadingImpl> get copyWith =>
      __$$BPReadingImplCopyWithImpl<_$BPReadingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BPReadingImplToJson(
      this,
    );
  }
}

abstract class _BPReading implements BPReading {
  const factory _BPReading(
      {@HiveField(0) required final String id,
      @HiveField(1) required final DateTime timestamp,
      @HiveField(2) required final int systolic,
      @HiveField(3) required final int diastolic,
      @HiveField(4) required final int pulse,
      @HiveField(5) final bool isManual,
      @HiveField(6) final String? notes}) = _$BPReadingImpl;

  factory _BPReading.fromJson(Map<String, dynamic> json) =
      _$BPReadingImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  DateTime get timestamp;
  @override
  @HiveField(2)
  int get systolic;
  @override
  @HiveField(3)
  int get diastolic;
  @override
  @HiveField(4)
  int get pulse;
  @override
  @HiveField(5)
  bool get isManual;
  @override
  @HiveField(6)
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$BPReadingImplCopyWith<_$BPReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
