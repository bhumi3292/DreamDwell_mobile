import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';

class ExplorePropertyModel extends ExplorePropertyEntity {
  ExplorePropertyModel({
    super.id,
    super.images,
    super.videos,
    super.title,
    super.location,
    super.bedrooms,
    super.bathrooms,
    super.categoryId,
    super.categoryName,
    super.price,
    super.description,
    super.landlordId,
    super.landlordName,
    super.landlordEmail,
    super.landlordPhone,
  });

  factory ExplorePropertyModel.fromJson(Map<String, dynamic> json) {
    return ExplorePropertyModel(
      id: json['_id']?.toString(),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      videos: json['videos'] != null ? List<String>.from(json['videos']) : [],
      title: json['title']?.toString(),
      location: json['location']?.toString(),
      bedrooms: json['bedrooms'] != null ? int.tryParse(json['bedrooms'].toString()) : null,
      bathrooms: json['bathrooms'] != null ? int.tryParse(json['bathrooms'].toString()) : null,
      categoryId: json['categoryId']?['_id']?.toString() ?? json['categoryId']?.toString(),
      categoryName: json['categoryId']?['category_name']?.toString(),
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      description: json['description']?.toString(),
      landlordId: json['landlord']?['_id']?.toString() ?? json['landlord']?.toString(),
      landlordName: json['landlord']?['fullName']?.toString(),
      landlordEmail: json['landlord']?['email']?.toString(),
      landlordPhone: json['landlord']?['phoneNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'images': images,
      'videos': videos,
      'title': title,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'categoryId': categoryId,
      'category_name': categoryName,
      'price': price,
      'description': description,
      'landlordId': landlordId,
      'landlordName': landlordName,
      'landlordEmail': landlordEmail,
      'landlordPhone': landlordPhone,
    };
  }
} 