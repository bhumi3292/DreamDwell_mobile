// lib/features/add_property/domain/repository/property_repository.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';

abstract interface class IPropertyRepository {

  // ⭐ THIS IS THE LINE THAT NEEDS TO BE CORRECTED IN YOUR IPropertyRepository FILE ⭐
  // It must match the parameters in your PropertyLocalRepository's addProperty method.
  Future<Either<Failure, void>> addProperty(
      PropertyEntity property,
      List<String> imagePaths, // <--- ADD THIS
      List<String> videoPaths, // <--- ADD THIS
      );

  Future<Either<Failure, void>> deleteProperty(String propertyId);
  Future<Either<Failure, List<PropertyEntity>>> getProperties();
  Future<Either<Failure, PropertyEntity>> getPropertyById(String propertyId);

  // ⭐ THIS IS THE LINE THAT NEEDS TO BE CORRECTED IN YOUR IPropertyRepository FILE ⭐
  // It must match the parameters in your PropertyLocalRepository's updateProperty method.
  Future<Either<Failure, void>> updateProperty(
      String propertyId,
      PropertyEntity updatedProperty,
      List<String> newImagePaths,
      List<String> newVideoPaths,
      List<String> existingImages,
      List<String> existingVideos,
      );
}