// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioDataAdapter extends TypeAdapter<AudioData> {
  @override
  final int typeId = 0;

  @override
  AudioData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioData(
      name: fields[0] as String,
      title: fields[1] as String,
      length: fields[2] as String,
      mainCategoryTitle: fields[6] as String,
      categoryTitle: fields[7] as String,
      subcategoryTitle: fields[8] as String,
      subcategoryDescription: fields[9] as String,
      lessonTitle: fields[10] as String,
      onlineUrl: fields[3] as String?,
    )
      ..isAvilableOffline = fields[4] as bool?
      ..offlineFilePath = fields[5] as String?
      ..isFav = fields[11] as bool?;
  }

  @override
  void write(BinaryWriter writer, AudioData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.onlineUrl)
      ..writeByte(4)
      ..write(obj.isAvilableOffline)
      ..writeByte(5)
      ..write(obj.offlineFilePath)
      ..writeByte(6)
      ..write(obj.mainCategoryTitle)
      ..writeByte(7)
      ..write(obj.categoryTitle)
      ..writeByte(8)
      ..write(obj.subcategoryTitle)
      ..writeByte(9)
      ..write(obj.subcategoryDescription)
      ..writeByte(10)
      ..write(obj.lessonTitle)
      ..writeByte(11)
      ..write(obj.isFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
