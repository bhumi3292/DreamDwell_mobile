// lib/features/add_property/data/data_source/property_data_source.dart

// REMOVE THIS LINE: import 'package:dio/dio.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

abstract interface class IPropertyDataSource {
  Future<void> addProperty(PropertyEntity property, List<String> imagePaths, List<String> videoPaths);
  Future<List<PropertyEntity>> getProperties();
  Future<PropertyEntity> getPropertyById(String propertyId);
  Future<void> updateProperty(String propertyId, PropertyEntity property, List<String> newImagePaths, List<String> newVideoPaths);
  Future<void> deleteProperty(String propertyId);
}