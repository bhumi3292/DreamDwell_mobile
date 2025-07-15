import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';

abstract class ExploreRepository {
  Future<Either<Failure, List<ExplorePropertyEntity>>> getAllProperties();
} 