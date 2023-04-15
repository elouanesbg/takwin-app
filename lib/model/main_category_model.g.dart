// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainCategoryAdapter extends TypeAdapter<MainCategory> {
  @override
  final int typeId = 0;

  @override
  MainCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainCategory(
      title: fields[0] as String,
      categorys: (fields[1] as List).cast<Category>(),
    );
  }

  @override
  void write(BinaryWriter writer, MainCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.categorys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
