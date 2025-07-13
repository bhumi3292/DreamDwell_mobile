// lib/features/add_property/domain/use_case/category/get_all_categories_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/category_repository.dart';

class GetAllCategoriesUsecase implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository repository;

  GetAllCategoriesUsecase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    print('GetAllCategoriesUsecase: Calling repository.getCategories()');
    final result = await repository.getCategories();
    result.fold(
      (failure) => print('GetAllCategoriesUsecase: Failed - ${failure.message}'),
      (categories) => print('GetAllCategoriesUsecase: Success - ${categories.length} categories'),
    );
    return result;
  }
}