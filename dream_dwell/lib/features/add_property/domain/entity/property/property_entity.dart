import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String? id;
  final List<String>? images;
  final List<String>? videos;
  final String? title;
  final String? location;
  final int? bedrooms;
  final int? bathrooms;
  final String? categoryId;
  final double? price;
  final String? description;
  final String? landlordId; // Optional - can be null for unauthenticated users
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? category; // Populated category object
  final Map<String, dynamic>? landlord; // Populated landlord object

  const PropertyEntity({
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
    this.category,
    this.landlord,
  });

  factory PropertyEntity.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    if (json['categoryId'] != null) {
      if (json['categoryId'] is String) {
        categoryId = json['categoryId'] as String;
      } else if (json['categoryId'] is Map<String, dynamic>) {
        categoryId = json['categoryId']['_id'] as String?;
      }
    }

    String? landlordId;
    if (json['landlord'] != null) {
      if (json['landlord'] is String) {
        landlordId = json['landlord'] as String;
      } else if (json['landlord'] is Map<String, dynamic>) {
        landlordId = json['landlord']['_id'] as String?;
      }
    }

    return PropertyEntity(
      id: json['_id'] as String?,
      images: (json['images'] as List?)?.map((e) => e as String).toList(),
      videos: (json['videos'] as List?)?.map((e) => e as String).toList(),
      title: json['title'] as String?,
      location: json['location'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      categoryId: categoryId,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      landlordId: landlordId,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      category: json['categoryId'] is Map<String, dynamic> ? json['categoryId'] as Map<String, dynamic> : null,
      landlord: json['landlord'] is Map<String, dynamic> ? json['landlord'] as Map<String, dynamic> : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      '_id': id,
      'images': images,
      'videos': videos,
      'title': title,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'categoryId': categoryId,
      'price': price,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'category': category,
      'landlord': landlord,
    };
    if (landlordId != null) {
      json['landlordId'] = landlordId;
    }
    return json;
  }

  PropertyEntity copyWith({
    String? id,
    List<String>? images,
    List<String>? videos,
    String? title,
    String? location,
    int? bedrooms,
    int? bathrooms,
    String? categoryId,
    double? price,
    String? description,
    String? landlordId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? category,
    Map<String, dynamic>? landlord,
  }) {
    return PropertyEntity(
      id: id ?? this.id,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      title: title ?? this.title,
      location: location ?? this.location,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      description: description ?? this.description,
      landlordId: landlordId ?? this.landlordId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      landlord: landlord ?? this.landlord,
    );
  }

  @override
  List<Object?> get props => [
    id,
    images,
    videos,
    title,
    location,
    bedrooms,
    bathrooms,
    categoryId,
    price,
    description,
    landlordId,
    createdAt,
    updatedAt,
    category,
    landlord,
  ];
}