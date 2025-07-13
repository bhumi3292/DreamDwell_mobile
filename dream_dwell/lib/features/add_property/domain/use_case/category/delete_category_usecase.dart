// lib/features/add_property/domain/use_case/category/delete_category_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/repository/category_repository.dart';

class DeleteCategoryUsecase {
  final ICategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(String categoryId) async {
    return await repository.deleteCategory(categoryId);
  }
}