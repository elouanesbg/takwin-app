// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_metadata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioMetadataModelAdapter extends TypeAdapter<AudioMetadataModel> {
  @override
  final int typeId = 1;

  @override
  AudioMetadataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioMetadataModel(
      mainCategoryTitle: fields[0] as String?,
      categoryTitle: fields[1] as String?,
      subCategoryTitle: fields[2] as String?,
      lessonTitle: fields[3] as String?,
      audioFileTitle: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AudioMetadataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.mainCategoryTitle)
      ..writeByte(1)
      ..write(obj.categoryTitle)
      ..writeByte(2)
      ..write(obj.subCategoryTitle)
      ..writeByte(3)
      ..write(obj.lessonTitle)
      ..writeByte(4)
      ..write(obj.audioFileTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioMetadataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
