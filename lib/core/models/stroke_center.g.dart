// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stroke_center.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StrokeCenterImplAdapter extends TypeAdapter<_$StrokeCenterImpl> {
  @override
  final int typeId = 1;

  @override
  _$StrokeCenterImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$StrokeCenterImpl(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      phone: fields[5] as String,
      hasScanner: fields[6] as bool,
      isOpen247: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$StrokeCenterImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.hasScanner)
      ..writeByte(7)
      ..write(obj.isOpen247);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrokeCenterImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrokeCenterImpl _$$StrokeCenterImplFromJson(Map<String, dynamic> json) =>
    _$StrokeCenterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String,
      hasScanner: json['hasScanner'] as bool? ?? false,
      isOpen247: json['isOpen247'] as bool? ?? true,
    );

Map<String, dynamic> _$$StrokeCenterImplToJson(_$StrokeCenterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'hasScanner': instance.hasScanner,
      'isOpen247': instance.isOpen247,
    };
