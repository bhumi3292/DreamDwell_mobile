import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/explore/domain/entity/explore_property_entity.dart';
import 'package:dream_dwell/features/explore/domain/use_case/get_all_properties_usecase.dart';

// Events
abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class GetPropertiesEvent extends ExploreEvent {}

class FilterPropertiesEvent extends ExploreEvent {
  final String searchText;
  final String? categoryId;
  final double? maxPrice;

  const FilterPropertiesEvent({
    required this.searchText,
    this.categoryId,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [searchText, categoryId, maxPrice];
}

// States
abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<ExplorePropertyEntity> properties;
  final List<ExplorePropertyEntity> filteredProperties;

  const ExploreLoaded({
    required this.properties,
    required this.filteredProperties,
  });

  @override
  List<Object?> get props => [properties, filteredProperties];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExplorePropertiesUsecase getAllPropertiesUsecase;
  List<ExplorePropertyEntity> _allProperties = [];

  ExploreBloc({required this.getAllPropertiesUsecase}) : super(ExploreInitial()) {
    on<GetPropertiesEvent>(_onGetProperties);
    on<FilterPropertiesEvent>(_onFilterProperties);
  }

  Future<void> _onGetProperties(
    GetPropertiesEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoading());

    final result = await getAllPropertiesUsecase();
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (properties) {
        _allProperties = properties;
        emit(ExploreLoaded(
          properties: properties,
          filteredProperties: properties,
        ));
      },
    );
  }

  void _onFilterProperties(
    FilterPropertiesEvent event,
    Emitter<ExploreState> emit,
  ) {
    final filteredProperties = _allProperties.where((property) {
      final matchesSearch = event.searchText.isEmpty ||
          (property.title?.toLowerCase().contains(event.searchText.toLowerCase()) ?? false) ||
          (property.location?.toLowerCase().contains(event.searchText.toLowerCase()) ?? false);
      final matchesCategory = event.categoryId == null || property.categoryId == event.categoryId;
      final matchesPrice = event.maxPrice == null || (property.price ?? 0) <= event.maxPrice!;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    emit(ExploreLoaded(
      properties: _allProperties,
      filteredProperties: filteredProperties,
    ));
  }
} 