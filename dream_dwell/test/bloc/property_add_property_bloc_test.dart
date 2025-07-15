// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:dartz/dartz.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dream_dwell/cores/error/failure.dart';
// import 'package:dream_dwell/features/add_property/domain/use_case/property/add_property_usecase.dart';
// import 'package:dream_dwell/features/add_property/domain/use_case/category/get_all_categories_usecase.dart';
// import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
// import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_view_model.dart';
// import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_event.dart';
// import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_state.dart';
//
// @GenerateMocks([AddPropertyUsecase, GetAllCategoriesUsecase])
// import 'property_add_property_bloc_test.mocks.dart';
//
// void main() {
//   late AddPropertyBloc addPropertyBloc;
//   late MockAddPropertyUsecase mockAddPropertyUsecase;
//   late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
//
//   setUp(() {
//     mockAddPropertyUsecase = MockAddPropertyUsecase();
//     mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
//     addPropertyBloc = AddPropertyBloc(
//       addPropertyUsecase: mockAddPropertyUsecase,
//       getAllCategoriesUsecase: mockGetAllCategoriesUsecase,
//     );
//   });
//
//   final List<CategoryEntity> testCategories = [
//     const CategoryEntity(
//       id: '1',
//       categoryName: 'Apartment',
//     ),
//     const CategoryEntity(
//       id: '2',
//       categoryName: 'House',
//     ),
//   ];
//
//   final testXFile = XFile('test_image.jpg');
//
//   group('AddPropertyBloc', () {
//     test('initial state should be AddPropertyInitial', () {
//       expect(addPropertyBloc.state, const AddPropertyInitial());
//     });
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadingState, AddPropertyLoadedState] when InitializeAddPropertyForm is successful',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) => bloc.add(const InitializeAddPropertyForm()),
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadingState, AddPropertyErrorState] when InitializeAddPropertyForm fails',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => const Left(NetworkFailure(message: 'Failed to load categories')),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) => bloc.add(const InitializeAddPropertyForm()),
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyErrorState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with selectedCategoryId] when SelectCategoryEvent is added',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(const SelectCategoryEvent(categoryId: '1'));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with selectedImages] when AddImageEvent is added',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(AddImageEvent(image: testXFile));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with selectedVideos] when AddVideoEvent is added',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(AddVideoEvent(video: testXFile));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with isSubmitting: true, AddPropertySubmissionSuccess] when SubmitPropertyEvent is successful',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         when(mockAddPropertyUsecase(any)).thenAnswer(
//           (_) async => const Right(null),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(const SubmitPropertyEvent(
//           title: 'Test Property',
//           location: 'Test Location',
//           price: '1000',
//           description: 'Test Description',
//           bedrooms: '2',
//           bathrooms: '1',
//           categoryId: '1',
//           context: null,
//         ));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertySubmissionSuccess>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with isSubmitting: true, AddPropertyLoadedState with error] when SubmitPropertyEvent fails',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         when(mockAddPropertyUsecase(any)).thenAnswer(
//           (_) async => const Left(NetworkFailure(message: 'Failed to add property')),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(const SubmitPropertyEvent(
//           title: 'Test Property',
//           location: 'Test Location',
//           price: '1000',
//           description: 'Test Description',
//           bedrooms: '2',
//           bathrooms: '1',
//           categoryId: '1',
//           context: null,
//         ));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//
//     blocTest<AddPropertyBloc, AddPropertyState>(
//       'emits [AddPropertyLoadedState with isSubmitting: true, AddPropertyLoadedState with validation error] when SubmitPropertyEvent has empty fields',
//       build: () {
//         when(mockGetAllCategoriesUsecase()).thenAnswer(
//           (_) async => Right(testCategories),
//         );
//         return addPropertyBloc;
//       },
//       act: (bloc) {
//         bloc.add(const InitializeAddPropertyForm());
//         bloc.add(const SubmitPropertyEvent(
//           title: '',
//           location: '',
//           price: '',
//           description: '',
//           bedrooms: '',
//           bathrooms: '',
//           categoryId: null,
//           context: null,
//         ));
//       },
//       expect: () => [
//         isA<AddPropertyLoadingState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//         isA<AddPropertyLoadedState>(),
//       ],
//     );
//   });
// }