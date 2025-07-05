import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

part 'property_api_model.g.dart';

@JsonSerializable()
class PropertyApiModel extends Equatable {
  @JsonKey(name: '_id')
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
  @JsonKey(name: 'landlord')
  final String landlordId;

  const PropertyApiModel({
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

  factory PropertyApiModel.fromJson(Map<String, dynamic> json) => _$PropertyApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyApiModelToJson(this);


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

  @override
  bool get stringify => true;

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