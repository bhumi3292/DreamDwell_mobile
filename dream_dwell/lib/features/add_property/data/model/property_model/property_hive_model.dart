// lib/features/add_property/data/model/property_model/property_hive_model.dart
import 'package:hive/hive.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart'; // Import the domain entity

part 'property_hive_model.g.dart';

@HiveType(typeId: 1) // Ensure this typeId is unique across ALL your Hive models
class PropertyHiveModel extends PropertyEntity { // You can extend PropertyEntity here
  // All fields are inherited if you extend PropertyEntity, but you need to define them with @HiveField
  // if you want them to be stored.

  // Explicitly redefine fields with @HiveField
  @override @HiveField(0)
  final String? id;
  @override @HiveField(1)
  final List<String>? images;
  @override @HiveField(2)
  final List<String>? videos;
  @override @HiveField(3)
  final String? title;
  @override @HiveField(4)
  final String? location;
  @override @HiveField(5)
  final int? bedrooms;
  @override @HiveField(6)
  final int? bathrooms;
  @override @HiveField(7)
  final String? categoryId; // Consistent with PropertyEntity's latest version
  @override @HiveField(8)
  final double? price;
  @override @HiveField(9)
  final String? description;
  @override @HiveField(10)
  final String? landlordId;
  @override @HiveField(11)
  final DateTime? createdAt;
  @override @HiveField(12)
  final DateTime? updatedAt;


  const PropertyHiveModel({
    this.id,
    this.images,
    this.videos,
    this.title,
    this.location,
    this.bedrooms,
    this.bathrooms,
    this.categoryId,
    this.price,
    this.description,
    this.landlordId,
    this.createdAt,
    this.updatedAt,
  }) : super(
    // Pass all fields to the super constructor
    id: id,
    images: images,
    videos: videos,
    title: title,
    location: location,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    categoryId: categoryId,
    price: price,
    description: description,
    landlordId: landlordId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  // Factory constructor to create a PropertyHiveModel from a PropertyEntity
  factory PropertyHiveModel.fromEntity(PropertyEntity entity) {
    return PropertyHiveModel(
      id: entity.id,
      images: entity.images,
      videos: entity.videos,
      title: entity.title,
      location: entity.location,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
      categoryId: entity.categoryId,
      price: entity.price,
      description: entity.description,
      landlordId: entity.landlordId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ⭐ ADD THIS METHOD: Convert a PropertyHiveModel back to a PropertyEntity ⭐
  PropertyEntity toEntity() {
    return PropertyEntity(
      id: id,
      images: images,
      videos: videos,
      title: title,
      location: location,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      categoryId: categoryId,
      price: price,
      description: description,
      landlordId: landlordId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // If you override props, ensure it includes all fields, especially if you added more.
  @override
  List<Object?> get props => [
    id, images, videos, title, location, bedrooms, bathrooms,
    categoryId, price, description, landlordId, createdAt, updatedAt
  ];
}