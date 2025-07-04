import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'property_hive_model.g.dart';

@HiveType(typeId: 1)
class PropertyEntity extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<String> images;
  @HiveField(2)
  final List<String>? videos;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String location;
  @HiveField(5)
  final int? bedrooms;
  @HiveField(6)
  final int? bathrooms;
  @HiveField(7)
  final String categoryName;
  @HiveField(8)
  final double price;
  @HiveField(9)
  final String? description;
  @HiveField(10)
  final String landlordId;

  const PropertyEntity({
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

  @override
  List<Object?> get props => [
    id, images, videos, title, location, bedrooms, bathrooms,
    categoryName, price, description, landlordId
  ];
}