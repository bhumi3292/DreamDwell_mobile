// lib/features/add_property/data/repository/category_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/data/data_source/category/category_data_source.dart'; // The interface for datasources
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/category_repository.dart'; // The domain repository interface

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryDataSource _localDataSource; // Injected local datasource
  final ICategoryDataSource _remoteDataSource; // Injected remote datasource

  CategoryRepositoryImpl({
    required ICategoryDataSource localDataSource,
    required ICategoryDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  // Helper to convert DioException to Failure types (can be extracted to a helper)
  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
      return NetworkFailure(message: 'No Internet Connection or Timeout');
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final errorMessage = e.response?.data['message'] ?? e.message;
      if (statusCode != null) {
        if (statusCode == 400) {
          return InputFailure(message: errorMessage);
        } else if (statusCode == 401) {
          return AuthFailure(message: errorMessage);
        } else if (statusCode == 403) {
          return ForbiddenFailure(message: errorMessage);
        } else if (statusCode == 404) {
          return NotFoundFailure(message: errorMessage);
        } else if (statusCode >= 500) {
          return ServerFailure(message: 'Server error: $errorMessage');
        }
      }
    }
    return UnknownFailure(message: e.message ?? 'An unknown network error occurred');
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryEntity category) async {
    try {
      // Always try to add remotely first
      await _remoteDataSource.addCategory(category);
      // If remote is successful, cache locally
      await _localDataSource.addCategory(category);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on Exception catch (e) {
      // Fallback for other exceptions from local storage operations
      return Left(LocalDatabaseFailure(message: 'Failed to add category (local cache error): ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      // Delete remotely
      await _remoteDataSource.deleteCategory(categoryId);
      // Then delete from local cache
      await _localDataSource.deleteCategory(categoryId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on Exception catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to delete category (local cache error): ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      // Try to get from remote first
      final remoteCategories = await _remoteDataSource.getCategories();
      // If successful, update local cache
      for (var category in remoteCategories) {
        // This will add or update based on ID (assuming addCategory handles update if ID exists)
        await _localDataSource.addCategory(category);
      }
      return Right(remoteCategories);
    } on DioException catch (e) {
      // If remote fails (e.g., no internet), try local cache
      print('Remote categories failed (${e.response?.statusCode ?? e.message}), trying local cache...');
      try {
        final localCategories = await _localDataSource.getCategories();
        if (localCategories.isNotEmpty) {
          return Right(localCategories);
        } else {
          // If local cache is also empty, return the remote error
          return Left(_handleDioError(e));
        }
      } on Exception catch (localE) {
        // If both remote and local fail
        return Left(CacheFailure(message: 'Remote failed: ${e.message}. Local cache failed: ${localE.toString()}'));
      }
    } on Exception catch (e) {
      // General error for remote
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      // Update remotely
      await _remoteDataSource.updateCategory(category);
      // Then update local cache
      await _localDataSource.updateCategory(category);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on Exception catch (e) {
      return Left(LocalDatabaseFailure(message: 'Failed to update category (local cache error): ${e.toString()}'));
    }
  }
}