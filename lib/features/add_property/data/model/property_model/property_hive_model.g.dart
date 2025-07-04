// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyEntityAdapter extends TypeAdapter<PropertyEntity> {
  @override
  final int typeId = 1;

  @override
  PropertyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyEntity(
      id: fields[0] as String,
      images: (fields[1] as List).cast<String>(),
      videos: (fields[2] as List?)?.cast<String>(),
      title: fields[3] as String,
      location: fields[4] as String,
      bedrooms: fields[5] as int?,
      bathrooms: fields[6] as int?,
      categoryName: fields[7] as String,
      price: fields[8] as double,
      description: fields[9] as String?,
      landlordId: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyEntity obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.categoryName)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.landlordId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
