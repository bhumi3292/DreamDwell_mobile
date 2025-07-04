import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String? id;
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

  const PropertyEntity({
    this.id,
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

  @override
  List<Object?> get props => [
    id,
    images,
    videos,
    title,
    location,
    bedrooms,
    bathrooms,
    categoryName,
    price,
    description,
    landlordId,
  ];

  PropertyEntity copyWith({
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
    return PropertyEntity(
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