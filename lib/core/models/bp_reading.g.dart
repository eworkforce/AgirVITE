// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_reading.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BPReadingImplAdapter extends TypeAdapter<_$BPReadingImpl> {
  @override
  final int typeId = 0;

  @override
  _$BPReadingImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$BPReadingImpl(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      systolic: fields[2] as int,
      diastolic: fields[3] as int,
      pulse: fields[4] as int,
      isManual: fields[5] as bool,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$BPReadingImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.systolic)
      ..writeByte(3)
      ..write(obj.diastolic)
      ..writeByte(4)
      ..write(obj.pulse)
      ..writeByte(5)
      ..write(obj.isManual)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BPReadingImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BPReadingImpl _$$BPReadingImplFromJson(Map<String, dynamic> json) =>
    _$BPReadingImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      pulse: (json['pulse'] as num).toInt(),
      isManual: json['isManual'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$BPReadingImplToJson(_$BPReadingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'systolic': instance.systolic,
      'diastolic': instance.diastolic,
      'pulse': instance.pulse,
      'isManual': instance.isManual,
      'notes': instance.notes,
    };
