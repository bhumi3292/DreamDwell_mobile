// lib/features/add_property/domain/use_case/get_property_by_id_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/property_repository.dart';

class GetPropertyByIdUsecase {
  final IPropertyRepository repository;

  GetPropertyByIdUsecase(this.repository);

  Future<Either<Failure, PropertyEntity>> call(String propertyId) async {
    return await repository.getPropertyById(propertyId);
  }
}