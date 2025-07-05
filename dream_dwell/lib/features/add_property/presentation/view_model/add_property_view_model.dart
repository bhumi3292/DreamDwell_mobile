// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
// import 'package:dream_dwell/features/property/domain/use_case/add_property_usecase.dart';
// import 'package:dream_dwell/features/property/domain/use_case/get_categories_usecase.dart';
// import 'package:dream_dwell/features/property/domain/use_case/create_category_usecase.dart';
// import 'package:dream_dwell/features/property/domain/entity/category_entity.dart';
//
// import 'add_property_event.dart';
// import 'add_property_state.dart';
//
// class AddPropertyViewModel extends Bloc<AddPropertyEvent, AddPropertyState> {
//   final AddPropertyUseCase _addPropertyUseCase;
//   final GetCategoriesUseCase _getCategoriesUseCase;
//   final CreateCategoryUseCase _createCategoryUseCase;
//
//   AddPropertyViewModel(
//       this._addPropertyUseCase,
//       this._getCategoriesUseCase,
//       this._createCategoryUseCase,
//       ) : super(const AddPropertyState.initial()) {
//     on<AddNewPropertyEvent>(_onAddNewProperty);
//     on<ClearAddPropertyMessageEvent>(_onClearMessage);
//     on<FetchCategoriesEvent>(_onFetchCategories);
//     on<AddCategoryEvent>(_onAddCategory);
//   }
//
//   void _onClearMessage(
//       ClearAddPropertyMessageEvent event,
//       Emitter<AddPropertyState> emit,
//       ) {
//     emit(state.copyWith(
//       errorMessage: null,
//       successMessage: null,
//       isSuccess: false,
//       addCategoryErrorMessage: null,
//       addCategorySuccessMessage: null,
//     ));
//   }
//
//   Future<void> _onAddNewProperty(
//       AddNewPropertyEvent event,
//       Emitter<AddPropertyState> emit,
//       ) async {
//     emit(state.copyWith(
//       isLoading: true,
//       errorMessage: null,
//       successMessage: null,
//       isSuccess: false,
//     ));
//
//     final price = double.tryParse(event.price);
//     final bedrooms = int.tryParse(event.bedrooms);
//     final bathrooms = int.tryParse(event.bathrooms);
//
//     if (price == null || bedrooms == null || bathrooms == null) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: 'Invalid number format for price, bedrooms, or bathrooms.',
//       ));
//       if (event.context != null) {
//         showMySnackbar(
//             context: event.context!,
//             content: 'Invalid number format for price, bedrooms, or bathrooms.',
//             isSuccess: false);
//       }
//       return;
//     }
//
//     final result = await _addPropertyUseCase(
//       AddPropertyParams(
//         title: event.title,
//         location: event.location,
//         price: price,
//         description: event.description,
//         bedrooms: bedrooms,
//         bathrooms: bathrooms,
//         categoryId: event.categoryId,
//         images: event.images,
//         videos: event.videos,
//       ),
//     );
//
//     result.fold(
//           (failure) {
//         emit(state.copyWith(
//           isLoading: false,
//           errorMessage: failure.message,
//           isSuccess: false,
//         ));
//         if (event.context != null) {
//           showMySnackbar(
//             context: event.context!,
//             content: failure.message,
//             isSuccess: false,
//           );
//         }
//       },
//           (_) {
//         emit(state.copyWith(
//           isLoading: false,
//           successMessage: "Property added successfully!",
//           isSuccess: true,
//         ));
//         if (event.context != null) {
//           showMySnackbar(
//             context: event.context!,
//             content: "Property added successfully!",
//             isSuccess: true,
//           );
//         }
//       },
//     );
//   }
//
//   Future<void> _onFetchCategories(
//       FetchCategoriesEvent event,
//       Emitter<AddPropertyState> emit,
//       ) async {
//     emit(state.copyWith(
//       isLoading: true,
//       errorMessage: null,
//       successMessage: null,
//     ));
//
//     final result = await _getCategoriesUseCase();
//
//     result.fold(
//           (failure) {
//         emit(state.copyWith(
//           isLoading: false,
//           errorMessage: failure.message,
//         ));
//       },
//           (categories) {
//         emit(state.copyWith(
//           isLoading: false,
//           categories: categories,
//         ));
//       },
//     );
//   }
//
//   Future<void> _onAddCategory(
//       AddCategoryEvent event,
//       Emitter<AddPropertyState> emit,
//       ) async {
//     emit(state.copyWith(
//       isAddingCategory: true,
//       addCategoryErrorMessage: null,
//       addCategorySuccessMessage: null,
//     ));
//
//     final result = await _createCategoryUseCase(event.categoryName);
//
//     result.fold(
//           (failure) {
//         emit(state.copyWith(
//           isAddingCategory: false,
//           addCategoryErrorMessage: failure.message,
//         ));
//         showMySnackbar(
//             context: event.context, content: failure.message, isSuccess: false);
//       },
//           (newCategory) {
//         final updatedCategories = List<CategoryEntity>.from(state.categories)
//           ..add(newCategory);
//         emit(state.copyWith(
//           isAddingCategory: false,
//           addCategorySuccessMessage: "Category added successfully!",
//           categories: updatedCategories,
//         ));
//         showMySnackbar(
//             context: event.context, content: "Category added successfully!", isSuccess: true);
//       },
//     );
//   }
// }