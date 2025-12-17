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
      hasCTScanner: fields[5] as bool,
      phone: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$StrokeCenterImpl obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.hasCTScanner)
      ..writeByte(6)
      ..write(obj.phone);
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
      hasCTScanner: json['hasCTScanner'] as bool,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$StrokeCenterImplToJson(_$StrokeCenterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'hasCTScanner': instance.hasCTScanner,
      'phone': instance.phone,
    };
