import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

class PropertyConverter {
  /// Convert PropertyApiModel to ExplorePropertyEntity
  static ExplorePropertyEntity fromApiModel(PropertyApiModel apiModel) {
    return ExplorePropertyEntity(
      id: apiModel.id,
      images: apiModel.images,
      videos: apiModel.videos,
      title: apiModel.title,
      location: apiModel.location,
      bedrooms: apiModel.bedrooms,
      bathrooms: apiModel.bathrooms,
      categoryId: apiModel.categoryId,
      categoryName: null, // API model doesn't have category name
      price: apiModel.price,
      description: apiModel.description,
      landlordId: apiModel.landlordId,
      landlordName: 'Landlord ID: ${apiModel.landlordId}', // Show landlord ID as reference
      landlordPhone: null,
      landlordEmail: null,
    );
  }

  /// Convert PropertyEntity to ExplorePropertyEntity
  static ExplorePropertyEntity fromPropertyEntity(PropertyEntity propertyEntity) {
    return ExplorePropertyEntity(
      id: propertyEntity.id,
      images: propertyEntity.images,
      videos: propertyEntity.videos,
      title: propertyEntity.title,
      location: propertyEntity.location,
      bedrooms: propertyEntity.bedrooms,
      bathrooms: propertyEntity.bathrooms,
      categoryId: propertyEntity.categoryId,
      categoryName: null, // Property entity doesn't have category name
      price: propertyEntity.price,
      description: propertyEntity.description,
      landlordId: propertyEntity.landlordId,
      landlordName: 'Landlord ID: ${propertyEntity.landlordId}', // Show landlord ID as reference
      landlordPhone: null,
      landlordEmail: null,
    );
  }
} 