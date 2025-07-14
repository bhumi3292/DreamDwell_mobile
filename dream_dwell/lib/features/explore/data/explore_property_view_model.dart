import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'explore_property_repository.dart';

class ExplorePropertyViewModel {
  final ExplorePropertyRepository _repository;

  ExplorePropertyViewModel(this._repository);

  Future<List<PropertyEntity>> fetchProperties() async {
    return await _repository.fetchProperties();
  }
} 