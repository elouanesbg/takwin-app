// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubcategoryAdapter extends TypeAdapter<Subcategory> {
  @override
  final int typeId = 2;

  @override
  Subcategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subcategory(
      title: fields[0] as String,
      description: fields[1] as String,
      lessons: (fields[2] as List).cast<Lesson>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subcategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubcategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
