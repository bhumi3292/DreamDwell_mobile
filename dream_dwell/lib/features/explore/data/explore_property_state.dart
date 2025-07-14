import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

class ExplorePropertyState {
  List<PropertyEntity> allProperties = [];
  List<PropertyEntity> filteredProperties = [];
  String searchText = '';
  String? selectedCategory;
  double? maxPrice;
  Set<String> cartPropertyIds = {};

  void filterProperties() {
    filteredProperties = allProperties.where((property) {
      final matchesSearch = searchText.isEmpty ||
          (property.title?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
          (property.location?.toLowerCase().contains(searchText.toLowerCase()) ?? false);
      final matchesCategory = selectedCategory == null || property.categoryId == selectedCategory;
      final matchesPrice = maxPrice == null || (property.price ?? 0) <= maxPrice!;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }

  PropertyApiModel convertPropertyEntityToPropertyApiModel(PropertyEntity propertyEntity) {
    return PropertyApiModel(
      id: propertyEntity.id,
      images: propertyEntity.images ?? [],
      videos: propertyEntity.videos ?? [],
      title: propertyEntity.title ?? 'Unknown Property',
      location: propertyEntity.location ?? 'Unknown Location',
      bedrooms: propertyEntity.bedrooms,
      bathrooms: propertyEntity.bathrooms,
      categoryId: propertyEntity.categoryId ?? '',
      price: propertyEntity.price ?? 0.0,
      description: propertyEntity.description,
      landlordId: propertyEntity.landlordId ?? '',
    );
  }
} 