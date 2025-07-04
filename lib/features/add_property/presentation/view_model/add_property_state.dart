// import 'package:equatable/equatable.dart';
// import 'package:dream_dwell/features/property/domain/entity/category_entity.dart'; // Assuming you have this entity
//
// class AddPropertyState extends Equatable {
//   final bool isLoading;
//   final bool isSuccess;
//   final String? errorMessage;
//   final String? successMessage;
//   final List<CategoryEntity> categories;
//   final bool isAddingCategory;
//   final String? addCategoryErrorMessage;
//   final String? addCategorySuccessMessage;
//
//   const AddPropertyState({
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.errorMessage,
//     this.successMessage,
//     this.categories = const [],
//     this.isAddingCategory = false,
//     this.addCategoryErrorMessage,
//     this.addCategorySuccessMessage,
//   });
//
//   const AddPropertyState.initial()
//       : isLoading = false,
//         isSuccess = false,
//         errorMessage = null,
//         successMessage = null,
//         categories = const [],
//         isAddingCategory = false,
//         addCategoryErrorMessage = null,
//         addCategorySuccessMessage = null;
//
//   AddPropertyState copyWith({
//     bool? isLoading,
//     bool? isSuccess,
//     String? errorMessage,
//     String? successMessage,
//     List<CategoryEntity>? categories,
//     bool? isAddingCategory,
//     String? addCategoryErrorMessage,
//     String? addCategorySuccessMessage,
//   }) {
//     return AddPropertyState(
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//       categories: categories ?? this.categories,
//       isAddingCategory: isAddingCategory ?? this.isAddingCategory,
//       addCategoryErrorMessage: addCategoryErrorMessage,
//       addCategorySuccessMessage: addCategorySuccessMessage,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     isLoading,
//     isSuccess,
//     errorMessage,
//     successMessage,
//     categories,
//     isAddingCategory,
//     addCategoryErrorMessage,
//     addCategorySuccessMessage,
//   ];
// }