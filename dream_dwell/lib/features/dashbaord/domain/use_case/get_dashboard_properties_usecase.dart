import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/dashbaord/domain/repository/dashboard_repository.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

class GetDashboardPropertiesUsecase implements UsecaseWithoutParams<List<PropertyApiModel>> {
  final DashboardRepository _repository;

  GetDashboardPropertiesUsecase({required DashboardRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<PropertyApiModel>>> call() async {
    try {
      final properties = await _repository.getDashboardProperties();
      return Right(properties);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
} 