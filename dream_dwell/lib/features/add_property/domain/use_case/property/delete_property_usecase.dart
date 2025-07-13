// lib/features/add_property/domain/use_case/delete_property_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/repository/property_repository.dart';

class DeletePropertyUsecase {
  final IPropertyRepository repository;

  DeletePropertyUsecase(this.repository);

  Future<Either<Failure, void>> call(String propertyId) async {
    return await repository.deleteProperty(propertyId);
  }
}