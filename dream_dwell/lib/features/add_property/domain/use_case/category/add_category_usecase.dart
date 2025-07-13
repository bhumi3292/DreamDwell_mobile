// lib/features/add_property/domain/use_case/category/add_category_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/category_repository.dart'; // Correct path to ICategoryRepository

class AddCategoryUsecase {
  final ICategoryRepository repository;

  AddCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(CategoryEntity category) async {
    return await repository.addCategory(category);
  }
}