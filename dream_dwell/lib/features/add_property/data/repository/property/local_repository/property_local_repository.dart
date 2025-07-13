// lib/features/add_property/data/repository/property_local_repository.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/data/data_source/property/local_datasource/property_local_datasource.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/property_repository.dart'; // The domain repository interface

class PropertyLocalRepository implements IPropertyRepository {
  final PropertyLocalDatasource _localDataSource;

  PropertyLocalRepository({required PropertyLocalDatasource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, void>> addProperty(PropertyEntity property, List<String> imagePaths, List<String> videoPaths) async {
    try {
      await _localDataSource.addProperty(property, imagePaths, videoPaths);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to add property locally: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String propertyId) async {
    try {
      await _localDataSource.deleteProperty(propertyId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to delete property locally: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getProperties() async {
    try {
      final properties = await _localDataSource.getProperties();
      return Right(properties);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to get properties locally: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> getPropertyById(String propertyId) async {
    try {
      final property = await _localDataSource.getPropertyById(propertyId);
      return Right(property);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to get property by ID locally: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProperty(String propertyId, PropertyEntity property, List<String> newImagePaths, List<String> newVideoPaths) async {
    try {
      await _localDataSource.updateProperty(propertyId, property, newImagePaths, newVideoPaths);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to update property locally: ${e.toString()}'));
    }
  }
}