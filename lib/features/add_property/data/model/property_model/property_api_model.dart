import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart'

class PropertyApiModel extends Equatable {
  final String id;
  final List<String> images;
  final List<String>? videos;
  final String title;
  final String location;
  final int? bedrooms;
  final int? bathrooms;
  final String categoryName;
  final double price;
  final String? description;
  final String landlordId;

  const PropertyApiModel({
    required this.id,
    required this.images,
    this.videos,
    required this.title,
    required this.location,
    this.bedrooms,
    this.bathrooms,
    required this.categoryName,
    required this.price,
    this.description,
    required this.landlordId,
  });

  factory PropertyApiModel.fromMap(Map<String, dynamic> map) {
    return PropertyApiModel(
      id: map['_id'] as String,
      images: List<String>.from(map['images'] as List<dynamic>),
      videos: map['videos'] != null ? List<String>.from(map['videos'] as List<dynamic>) : null,
      title: map['title'] as String,
      location: map['location'] as String,
      bedrooms: map['bedrooms'] as int?,
      bathrooms: map['bathrooms'] as int?,
      categoryName: map['categoryName'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String?,
      landlordId: map['landlord'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'images': images,
      'videos': videos,
      'title': title,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'categoryName': categoryName,
      'price': price,
      'description': description,
      'landlord': landlordId,
    };
  }

  PropertyEntity toEntity() {
    return PropertyEntity(
      id: id,
      images: images,
      videos: videos,
      title: title,
      location: location,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      categoryName: categoryName,
      price: price,
      description: description,
      landlordId: landlordId,
    );
  }

  factory PropertyApiModel.fromEntity(PropertyEntity entity) {
    return PropertyApiModel(
      id: entity.id,
      images: entity.images,
      videos: entity.videos,
      title: entity.title,
      location: entity.location,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
      categoryName: entity.categoryName,
      price: entity.price,
      description: entity.description,
      landlordId: entity.landlordId,
    );
  }


  @override
  List<Object?> get props => [
    id, images, videos, title, location, bedrooms, bathrooms,
    categoryName, price, description, landlordId,
  ];

  // Optional: copyWith method for immutability
  PropertyApiModel copyWith({
    String? id,
    List<String>? images,
    List<String>? videos,
    String? title,
    String? location,
    int? bedrooms,
    int? bathrooms,
    String? categoryName,
    double? price,
    String? description,
    String? landlordId,
  }) {
    return PropertyApiModel(
      id: id ?? this.id,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      title: title ?? this.title,
      location: location ?? this.location,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      description: description ?? this.description,
      landlordId: landlordId ?? this.landlordId,
    );
  }
}