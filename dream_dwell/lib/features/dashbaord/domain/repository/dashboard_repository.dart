import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

abstract class DashboardRepository {
  Future<List<PropertyApiModel>> getDashboardProperties();
} 