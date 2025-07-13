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



class AddPropertyBloc extends Bloc<AddPropertyEvent, AddPropertyState> {
  final AddPropertyUsecase _addPropertyUsecase;
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;

  // Internal state for selected media and category ID
  // These will be updated by events and then copied into the emitted state.
  String? _selectedCategoryId;
  final List<XFile> _currentImages = [];
  final List<XFile> _currentVideos = [];
  List<CategoryEntity> _currentCategories = [];


  AddPropertyBloc({
    required AddPropertyUsecase addPropertyUsecase,
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
  })  : _addPropertyUsecase = addPropertyUsecase,
        _getAllCategoriesUsecase = getAllCategoriesUsecase,
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
    emit(AddPropertyLoadingState(categories: _currentCategories)); // Pass existing categories
    final result = await _getAllCategoriesUsecase();
    result.fold(
          (failure) => emit(AddPropertyErrorState(
        errorMessage: failure.message,
        categories: _currentCategories,
      )),
          (categories) {
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

    // Basic validation based on passed event data
    if (event.title.isEmpty ||
        event.location.isEmpty ||
        event.price.isEmpty ||
        event.description.isEmpty ||
        event.bedrooms.isEmpty ||
        event.bathrooms.isEmpty ||
        event.categoryId == null) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'All required fields must be filled.',
      ));
      if (event.context != null) {
        showMySnackbar(
          context: event.context!,
          content: 'All required fields must be filled.',
          isSuccess: false,
        );
      }
      return;
    }

    final property = PropertyEntity(
      id: null,
      title: event.title,
      location: event.location,
      price: double.tryParse(event.price) ?? 0.0,
      description: event.description,
      bedrooms: int.tryParse(event.bedrooms) ?? 0,
      bathrooms: int.tryParse(event.bathrooms) ?? 0,
      categoryId: event.categoryId!,
      // FIX: Changed 'ownerId' to 'landlordId' to match PropertyEntity constructor
      landlordId: 'some_owner_id', // This line now correctly maps to 'landlordId'
      images: const [],
      videos: const [],
    );

    final imagePaths = _currentImages.map((file) => file.path).toList();
    final videoPaths = _currentVideos.map((file) => file.path).toList();

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
          successMessage: "Property added successfully!",
          categories: List.from(_currentCategories), // Pass current categories
          selectedCategoryId: null, // Clear selected category
          selectedImages: [], // Clear selected images
          selectedVideos: [], // Clear selected videos
          isSubmitting: false,
        ));
        if (event.context != null) {
          showMySnackbar(
            context: event.context!,
            content: "Property added successfully!",
            isSuccess: true,
          );
        }
      },
    );
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