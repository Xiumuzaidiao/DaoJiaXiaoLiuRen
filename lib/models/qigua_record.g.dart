// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qigua_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QiGuaRecordAdapter extends TypeAdapter<QiGuaRecord> {
  @override
  final int typeId = 0;

  @override
  QiGuaRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QiGuaRecord(
      qiGuaShiXiang: fields[0] as String,
      date: fields[1] as String,
      time: fields[2] as String,
      liupai: fields[3] as String,
      leixing: fields[4] as String,
      detail: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QiGuaRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.qiGuaShiXiang)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.liupai)
      ..writeByte(4)
      ..write(obj.leixing)
      ..writeByte(5)
      ..write(obj.detail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QiGuaRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
