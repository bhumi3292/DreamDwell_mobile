import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/dashbaord/domain/use_case/get_dashboard_properties_usecase.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_api_model.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardProperties extends DashboardEvent {
  const LoadDashboardProperties();
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<PropertyApiModel> properties;
  final List<Map<String, dynamic>> landlordAvatars;
  final List<String> bigImageUrls;
  final List<PropertyApiModel> topProperties;

  const DashboardLoaded(this.properties, {
    required this.landlordAvatars,
    required this.bigImageUrls,
    required this.topProperties,
  });

  @override
  List<Object?> get props => [properties, landlordAvatars, bigImageUrls, topProperties];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// ViewModel/Bloc
class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardPropertiesUsecase _getDashboardPropertiesUsecase;

  DashboardViewModel({required GetDashboardPropertiesUsecase getDashboardPropertiesUsecase})
      : _getDashboardPropertiesUsecase = getDashboardPropertiesUsecase,
        super(const DashboardInitial()) {
    on<LoadDashboardProperties>(_onLoadDashboardProperties);
  }

  Future<void> _onLoadDashboardProperties(
    LoadDashboardProperties event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await _getDashboardPropertiesUsecase();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (properties) {
        // Compute landlord avatars (unique by email)
        final uniqueLandlords = <String, Map<String, dynamic>>{};
        for (final p in properties) {
          final landlord = p.landlord;
          if (landlord != null && landlord['email'] != null) {
            uniqueLandlords[landlord['email']] = landlord;
          }
        }
        final landlordAvatars = uniqueLandlords.values.toList();
        // Compute big image URLs (first image of each property)
        final bigImageUrls = properties.map((p) {
          if (p.images.isNotEmpty) {
            return p.images[0].startsWith('http') ? p.images[0] : 'http://10.0.2.2:3001/${p.images[0]}';
          }
          return '';
        }).toList();
        // Top 5 properties
        final topProperties = properties.length > 5 ? properties.sublist(0, 5) : properties;
        emit(DashboardLoaded(
          properties,
          landlordAvatars: landlordAvatars,
          bigImageUrls: bigImageUrls,
          topProperties: topProperties,
        ));
      },
    );
  }

  void loadProperties() {
    add(const LoadDashboardProperties());
  }
} 