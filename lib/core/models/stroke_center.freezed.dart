// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stroke_center.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StrokeCenter _$StrokeCenterFromJson(Map<String, dynamic> json) {
  return _StrokeCenter.fromJson(json);
}

/// @nodoc
mixin _$StrokeCenter {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get address => throw _privateConstructorUsedError;
  @HiveField(3)
  double get latitude => throw _privateConstructorUsedError;
  @HiveField(4)
  double get longitude => throw _privateConstructorUsedError;
  @HiveField(5)
  String get phone => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get hasScanner => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isOpen247 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StrokeCenterCopyWith<StrokeCenter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrokeCenterCopyWith<$Res> {
  factory $StrokeCenterCopyWith(
          StrokeCenter value, $Res Function(StrokeCenter) then) =
      _$StrokeCenterCopyWithImpl<$Res, StrokeCenter>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String address,
      @HiveField(3) double latitude,
      @HiveField(4) double longitude,
      @HiveField(5) String phone,
      @HiveField(6) bool hasScanner,
      @HiveField(7) bool isOpen247});
}

/// @nodoc
class _$StrokeCenterCopyWithImpl<$Res, $Val extends StrokeCenter>
    implements $StrokeCenterCopyWith<$Res> {
  _$StrokeCenterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = null,
    Object? hasScanner = null,
    Object? isOpen247 = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      hasScanner: null == hasScanner
          ? _value.hasScanner
          : hasScanner // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpen247: null == isOpen247
          ? _value.isOpen247
          : isOpen247 // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrokeCenterImplCopyWith<$Res>
    implements $StrokeCenterCopyWith<$Res> {
  factory _$$StrokeCenterImplCopyWith(
          _$StrokeCenterImpl value, $Res Function(_$StrokeCenterImpl) then) =
      __$$StrokeCenterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String address,
      @HiveField(3) double latitude,
      @HiveField(4) double longitude,
      @HiveField(5) String phone,
      @HiveField(6) bool hasScanner,
      @HiveField(7) bool isOpen247});
}

/// @nodoc
class __$$StrokeCenterImplCopyWithImpl<$Res>
    extends _$StrokeCenterCopyWithImpl<$Res, _$StrokeCenterImpl>
    implements _$$StrokeCenterImplCopyWith<$Res> {
  __$$StrokeCenterImplCopyWithImpl(
      _$StrokeCenterImpl _value, $Res Function(_$StrokeCenterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = null,
    Object? hasScanner = null,
    Object? isOpen247 = null,
  }) {
    return _then(_$StrokeCenterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      hasScanner: null == hasScanner
          ? _value.hasScanner
          : hasScanner // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpen247: null == isOpen247
          ? _value.isOpen247
          : isOpen247 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 1)
class _$StrokeCenterImpl implements _StrokeCenter {
  const _$StrokeCenterImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.address,
      @HiveField(3) required this.latitude,
      @HiveField(4) required this.longitude,
      @HiveField(5) required this.phone,
      @HiveField(6) this.hasScanner = false,
      @HiveField(7) this.isOpen247 = true});

  factory _$StrokeCenterImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrokeCenterImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String address;
  @override
  @HiveField(3)
  final double latitude;
  @override
  @HiveField(4)
  final double longitude;
  @override
  @HiveField(5)
  final String phone;
  @override
  @JsonKey()
  @HiveField(6)
  final bool hasScanner;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isOpen247;

  @override
  String toString() {
    return 'StrokeCenter(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, phone: $phone, hasScanner: $hasScanner, isOpen247: $isOpen247)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrokeCenterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.hasScanner, hasScanner) ||
                other.hasScanner == hasScanner) &&
            (identical(other.isOpen247, isOpen247) ||
                other.isOpen247 == isOpen247));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, address, latitude,
      longitude, phone, hasScanner, isOpen247);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StrokeCenterImplCopyWith<_$StrokeCenterImpl> get copyWith =>
      __$$StrokeCenterImplCopyWithImpl<_$StrokeCenterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrokeCenterImplToJson(
      this,
    );
  }
}

abstract class _StrokeCenter implements StrokeCenter {
  const factory _StrokeCenter(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String address,
      @HiveField(3) required final double latitude,
      @HiveField(4) required final double longitude,
      @HiveField(5) required final String phone,
      @HiveField(6) final bool hasScanner,
      @HiveField(7) final bool isOpen247}) = _$StrokeCenterImpl;

  factory _StrokeCenter.fromJson(Map<String, dynamic> json) =
      _$StrokeCenterImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get address;
  @override
  @HiveField(3)
  double get latitude;
  @override
  @HiveField(4)
  double get longitude;
  @override
  @HiveField(5)
  String get phone;
  @override
  @HiveField(6)
  bool get hasScanner;
  @override
  @HiveField(7)
  bool get isOpen247;
  @override
  @JsonKey(ignore: true)
  _$$StrokeCenterImplCopyWith<_$StrokeCenterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
