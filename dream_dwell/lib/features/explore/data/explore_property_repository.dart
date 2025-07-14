import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_all_properties_usecase.dart';
import 'package:get_it/get_it.dart';

class ExplorePropertyRepository {
  final GetAllPropertiesUsecase _getAllPropertiesUsecase = GetIt.instance<GetAllPropertiesUsecase>();

  Future<List<PropertyEntity>> fetchProperties() async {
    final result = await _getAllPropertiesUsecase();
    return result.fold((failure) {
      print('Error fetching properties:  [31m${failure.message} [0m');
      return [];
    }, (properties) {
      return properties;
    });
  }
} 