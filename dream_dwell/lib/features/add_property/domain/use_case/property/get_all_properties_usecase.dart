// lib/features/add_property/domain/use_case/get_all_properties_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/repository/property_repository.dart';

class GetAllPropertiesUsecase implements UsecaseWithoutParams<List<PropertyEntity>> {
  final IPropertyRepository repository;

  GetAllPropertiesUsecase(this.repository);

  @override
  Future<Either<Failure, List<PropertyEntity>>> call() async {
    return await repository.getProperties();
  }
}