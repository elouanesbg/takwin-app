// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_files_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioFilesAdapter extends TypeAdapter<AudioFiles> {
  @override
  final int typeId = 1;

  @override
  AudioFiles read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioFiles(
      name: fields[0] as String,
      title: fields[1] as String,
      length: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFiles obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.length);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFilesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
