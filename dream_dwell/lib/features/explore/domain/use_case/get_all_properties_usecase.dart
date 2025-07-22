import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/features/explore/domain/repository/explore_repository.dart';

class GetExplorePropertiesUsecase {
  final ExploreRepository repository;

  GetExplorePropertiesUsecase(this.repository);

  Future<Either<Failure, List<ExplorePropertyEntity>>> call() async {
    return await repository.getAllProperties();
  }
} 