// lib/features/add_property/presentation/bloc/add_property_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/category/get_all_categories_usecase.dart';
// Corrected imports - these are actual imports, not 'part' files
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_event.dart';
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_state.dart';
import 'package:image_picker/image_picker.dart'; // For XFile
// For BuildContext and TextEditingController
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart'; // Assuming you have this

import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/add_property_usecase.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyState> {
  final AddPropertyUsecase _addPropertyUsecase;
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final HiveService _hiveService;

  // Internal state for selected media and category ID
  // These will be updated by events and then copied into the emitted state.
  String? _selectedCategoryId;
  final List<XFile> _currentImages = [];
  final List<XFile> _currentVideos = [];
  List<CategoryEntity> _currentCategories = [];


  AddPropertyBloc({
    required AddPropertyUsecase addPropertyUsecase,
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
    required HiveService hiveService,
  })  : _addPropertyUsecase = addPropertyUsecase,
        _getAllCategoriesUsecase = getAllCategoriesUsecase,
        _hiveService = hiveService,
        super(const AddPropertyInitial()) {
    on<InitializeAddPropertyForm>(_onInitializeAddPropertyForm);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<AddImageEvent>(_onAddImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<AddVideoEvent>(_onAddVideo);
    on<RemoveVideoEvent>(_onRemoveVideo);
    on<NewCategoryAddedEvent>(_onNewCategoryAdded);
    on<SubmitPropertyEvent>(_onSubmitProperty);
    on<ClearAddPropertyMessageEvent>(_onClearAddPropertyMessage);
  }

  Future<void> _onInitializeAddPropertyForm(
      InitializeAddPropertyForm event,
      Emitter<AddPropertyState> emit,
      ) async {
    print('Initializing add property form...');
    emit(AddPropertyLoadingState(categories: _currentCategories)); // Pass existing categories
    final result = await _getAllCategoriesUsecase();
    result.fold(
          (failure) {
        print('Failed to load categories: ${failure.message}');
        emit(AddPropertyErrorState(
          errorMessage: failure.message,
          categories: _currentCategories,
        ));
      },
          (categories) {
        print('Successfully loaded ${categories.length} categories');
        _currentCategories = categories; // Update internal list
        emit(AddPropertyLoadedState(
          categories: _currentCategories,
          selectedCategoryId: _selectedCategoryId,
          selectedImages: List.from(_currentImages),
          selectedVideos: List.from(_currentVideos),
        ));
      },
    );
  }

  void _onSelectCategory(
      SelectCategoryEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    _selectedCategoryId = event.categoryId;
    // It's safer to always get the current state and then copy, rather than
    // casting to specific states, unless behavior differs greatly per state.
    // However, given your state structure, this is fine, but ensure `copyWith`
    // is robust in all states.
    emit(state.copyWith(
      selectedCategoryId: _selectedCategoryId,
      errorMessage: null, // Clear any previous error
    ));
  }

  void _onAddImage(
      AddImageEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    _currentImages.add(event.image);
    emit(state.copyWith(
      selectedImages: List.from(_currentImages),
      errorMessage: null, // Clear any previous error
    ));
  }

  void _onRemoveImage(
      RemoveImageEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    if (event.index >= 0 && event.index < _currentImages.length) {
      _currentImages.removeAt(event.index);
    }
    emit(state.copyWith(
      selectedImages: List.from(_currentImages),
      errorMessage: null, // Clear any previous error
    ));
  }

  void _onAddVideo(
      AddVideoEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    _currentVideos.add(event.video);
    emit(state.copyWith(
      selectedVideos: List.from(_currentVideos),
      errorMessage: null, // Clear any previous error
    ));
  }

  void _onRemoveVideo(
      RemoveVideoEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    if (event.index >= 0 && event.index < _currentVideos.length) {
      _currentVideos.removeAt(event.index);
    }
    emit(state.copyWith(
      selectedVideos: List.from(_currentVideos),
      errorMessage: null, // Clear any previous error
    ));
  }

  void _onNewCategoryAdded(
      NewCategoryAddedEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    _currentCategories.add(event.newCategory);
    _selectedCategoryId = event.newCategory.id; // Auto-select new category

    emit(state.copyWith(
      categories: List.from(_currentCategories),
      selectedCategoryId: _selectedCategoryId,
      errorMessage: null, // Clear any previous error
    ));
  }

  Future<void> _onSubmitProperty(
      SubmitPropertyEvent event,
      Emitter<AddPropertyState> emit,
      ) async {
    emit(state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
    ));

    // Enhanced validation
    final validationErrors = <String>[];
    
    if (event.title.trim().isEmpty) {
      validationErrors.add('Property title is required');
    }
    if (event.location.trim().isEmpty) {
      validationErrors.add('Property location is required');
    }
    if (event.price.trim().isEmpty) {
      validationErrors.add('Property price is required');
    } else {
      final price = double.tryParse(event.price);
      if (price == null || price <= 0) {
        validationErrors.add('Property price must be a valid number greater than 0');
      }
    }
    if (event.description.trim().isEmpty) {
      validationErrors.add('Property description is required');
    }
    if (event.bedrooms.trim().isEmpty) {
      validationErrors.add('Number of bedrooms is required');
    } else {
      final bedrooms = int.tryParse(event.bedrooms);
      if (bedrooms == null || bedrooms < 0) {
        validationErrors.add('Bedrooms must be a valid number (0 or more)');
      }
    }
    if (event.bathrooms.trim().isEmpty) {
      validationErrors.add('Number of bathrooms is required');
    } else {
      final bathrooms = int.tryParse(event.bathrooms);
      if (bathrooms == null || bathrooms < 0) {
        validationErrors.add('Bathrooms must be a valid number (0 or more)');
      }
    }
    if (event.categoryId == null || event.categoryId!.isEmpty) {
      validationErrors.add('Property category is required');
    }
    if (_currentImages.isEmpty) {
      validationErrors.add('At least one property image is required');
    }

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: validationErrors.join('\n'),
      ));
      if (event.context != null) {
        showMySnackbar(
          context: event.context!,
          content: validationErrors.join('\n'),
          isSuccess: false,
        );
      }
      return;
    }

    try {
      // For now, we'll use a default user ID or skip authentication
      // This allows property creation without login requirement
      String? userId;
      try {
        final currentUser = await _hiveService.getCurrentUser();
        userId = currentUser?.userId;
      } catch (e) {
        print('No authenticated user found, proceeding without user ID');
        // Continue without user ID - backend will handle this
      }

      final property = PropertyEntity(
        id: null,
        title: event.title.trim(),
        location: event.location.trim(),
        price: double.parse(event.price),
        description: event.description.trim(),
        bedrooms: int.parse(event.bedrooms),
        bathrooms: int.parse(event.bathrooms),
        categoryId: event.categoryId!,
        landlordId: userId, // Use user ID if available, otherwise null
        images: const [],
        videos: const [],
      );

      final imagePaths = _currentImages.map((file) => file.path).toList();
      final videoPaths = _currentVideos.map((file) => file.path).toList();

      print('Submitting property with data:');
      print('Title: ${property.title}');
      print('Location: ${property.location}');
      print('Price: ${property.price}');
      print('Category: ${property.categoryId}');
      print('Landlord ID: ${property.landlordId ?? "No user ID (proceeding without auth)"}');
      print('Images: ${imagePaths.length} files');
      print('Videos: ${videoPaths.length} files');

      final result = await _addPropertyUsecase(
        AddPropertyParams(
          property: property,
          imagePaths: imagePaths,
          videoPaths: videoPaths,
        ),
      );

      result.fold(
            (failure) {
          emit(state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
          ));
          if (event.context != null) {
            showMySnackbar(
              context: event.context!,
              content: failure.message,
              isSuccess: false,
            );
          }
        },
            (_) {
          // Reset local state after successful submission
          _selectedCategoryId = null;
          _currentImages.clear();
          _currentVideos.clear();
          // Keep _currentCategories for next form use
                  emit(AddPropertySubmissionSuccess(
          successMessage: "Property added successfully to backend!",
          categories: List.from(_currentCategories), // Pass current categories
          selectedCategoryId: null, // Clear selected category
          selectedImages: [], // Clear selected images
          selectedVideos: [], // Clear selected videos
          isSubmitting: false,
        ));
        if (event.context != null) {
          showMySnackbar(
            context: event.context!,
            content: "Property added successfully to backend!",
            isSuccess: true,
          );
        }
        },
      );
    } catch (e) {
      print('Exception in _onSubmitProperty: $e');
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred: $e',
      ));
      if (event.context != null) {
        showMySnackbar(
          context: event.context!,
          content: 'An unexpected error occurred: $e',
          isSuccess: false,
        );
      }
    }
  }

  void _onClearAddPropertyMessage(
      ClearAddPropertyMessageEvent event,
      Emitter<AddPropertyState> emit,
      ) {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}