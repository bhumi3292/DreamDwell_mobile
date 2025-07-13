// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyHiveModelAdapter extends TypeAdapter<PropertyHiveModel> {
  @override
  final int typeId = 1;

  @override
  PropertyHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyHiveModel(
      id: fields[0] as String?,
      images: (fields[1] as List?)?.cast<String>(),
      videos: (fields[2] as List?)?.cast<String>(),
      title: fields[3] as String?,
      location: fields[4] as String?,
      bedrooms: fields[5] as int?,
      bathrooms: fields[6] as int?,
      categoryId: fields[7] as String?,
      price: fields[8] as double?,
      description: fields[9] as String?,
      landlordId: fields[10] as String?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.videos)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.bedrooms)
      ..writeByte(6)
      ..write(obj.bathrooms)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.landlordId)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
