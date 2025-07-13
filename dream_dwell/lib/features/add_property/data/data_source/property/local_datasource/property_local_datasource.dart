// lib/features/add_property/data/data_source/local_datasource/property_local_datasource.dart

// No need for dartz import anymore
// import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/add_property/data/data_source/property/property_data_source.dart'; // The interface (IPropertyDataSource)
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart'; // ⭐ IMPORTANT: Import the domain entity ⭐
import 'package:dream_dwell/features/add_property/data/model/property_model/property_hive_model.dart'; // ⭐ IMPORTANT: Import the Hive model ⭐

class PropertyLocalDatasource implements IPropertyDataSource {
  final HiveService hiveService;

  PropertyLocalDatasource({required this.hiveService});

  @override
  Future<void> addProperty(PropertyEntity property, List<String> imagePaths, List<String> videoPaths) async {
    try {
      // ⭐ CONVERSION HERE: Convert domain entity to PropertyHiveModel ⭐
      final propertyHiveModel = PropertyHiveModel.fromEntity(property);
      await hiveService.addProperty(propertyHiveModel); // Pass the PropertyHiveModel
    } catch (e) {
      throw Exception('Failed to add property locally: $e');
    }
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    try {
      await hiveService.deletePropertyById(propertyId);
    } catch (e) {
      throw Exception('Failed to delete property locally: $e');
    }
  }

  @override
  Future<List<PropertyEntity>> getProperties() async {
    try {
      // Retrieve List<PropertyHiveModel> from HiveService
      final propertyHiveModels = await hiveService.getAllProperties();
      // ⭐ CONVERSION HERE: Convert List<PropertyHiveModel> to List<PropertyEntity> ⭐
      final properties = propertyHiveModels.map((model) => model.toEntity()).toList();
      return properties; // Correct: Dart automatically wraps this List<PropertyEntity> in a Future
    } catch (e) {
      throw Exception('Failed to get properties locally: $e');
    }
  }

  @override
  Future<PropertyEntity> getPropertyById(String propertyId) async {
    try {
      // Retrieve PropertyHiveModel from HiveService
      final propertyHiveModel = await hiveService.getPropertyById(propertyId);
      if (propertyHiveModel == null) {
        throw Exception('Property with ID $propertyId not found locally.');
      }
      // ⭐ CONVERSION HERE: Convert PropertyHiveModel to PropertyEntity ⭐
      return propertyHiveModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get property by ID locally: $e');
    }
  }

  @override
  Future<void> updateProperty(String propertyId, PropertyEntity property,
      List<String> newImagePaths, List<String> newVideoPaths) async {
    try {
      final updatedPropertyHiveModel = PropertyHiveModel.fromEntity(property);
      await hiveService.updateProperty(updatedPropertyHiveModel); // Pass the PropertyHiveModel
    } catch (e) {
      throw Exception('Failed to update property locally: $e');
    }
  }
}