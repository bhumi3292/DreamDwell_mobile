import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

// Auth
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:dream_dwell/features/auth/data/repository/remote_repository/register_remote_repository.dart'; // Assumed to be UserRemoteRepository
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Profile
import 'package:dream_dwell/features/profile/domain/use_case/upload_profile_picture_usecase.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';

// Property
import 'package:dream_dwell/features/add_property/data/data_source/property/remote_datasource/property_remote_datasource.dart';
import 'package:dream_dwell/features/add_property/data/repository/property/remote_repository/property_remote_repository.dart';
import 'package:dream_dwell/features/add_property/domain/repository/property_repository.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_all_properties_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/add_property_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/category/get_all_categories_usecase.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/category/add_category_usecase.dart';
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_view_model.dart';

// Category
import 'package:dream_dwell/features/add_property/data/data_source/category/remote_datasource/category_remote_datasource.dart';
import 'package:dream_dwell/features/add_property/data/repository/category/remote_repository/category_remote_repository.dart';
import 'package:dream_dwell/features/add_property/domain/repository/category_repository.dart';

// Cart
import 'package:dream_dwell/features/favourite/data/datasource/cart_api_service.dart';
import 'package:dream_dwell/features/favourite/data/repository/cart_repository_impl.dart';
import 'package:dream_dwell/features/favourite/domain/repository/cart_repository.dart';
import 'package:dream_dwell/features/favourite/domain/usecase/get_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/usecase/add_to_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/usecase/remove_from_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/domain/usecase/clear_cart_usecase.dart';
import 'package:dream_dwell/features/favourite/presentation/bloc/cart_bloc.dart';

// Dashboard
import 'package:dream_dwell/features/dashbaord/data/data_source/remote_datasource/dashboard_remote_datasource.dart';
import 'package:dream_dwell/features/dashbaord/data/repository/dashboard_repository_impl.dart';
import 'package:dream_dwell/features/dashbaord/domain/repository/dashboard_repository.dart';
import 'package:dream_dwell/features/dashbaord/domain/use_case/get_dashboard_properties_usecase.dart';
import 'package:dream_dwell/features/dashbaord/presentation/view_model/dashboard_view_model.dart';

// Explore
import 'package:dream_dwell/features/explore/data/data_source/explore_remote_data_source.dart';
import 'package:dream_dwell/features/explore/data/repository/explore_repository_impl.dart';
import 'package:dream_dwell/features/explore/domain/repository/explore_repository.dart';
import 'package:dream_dwell/features/explore/domain/use_case/get_all_properties_usecase.dart';
import 'package:dream_dwell/features/explore/presentation/bloc/explore_bloc.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiService();
  _initAuthAndProfileModules();
  _initPropertyModules();
  _initCartModules();
  _initDashboardModules();
  _initExploreModules();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

void _initApiService() {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<ApiService>(
        () => ApiService(
      serviceLocator<Dio>(),
      serviceLocator<HiveService>(),
    ),
  );
}

void _initPropertyModules() {
  // --- Property Data Sources ---
  serviceLocator.registerFactory<PropertyRemoteDatasource>(
    () => PropertyRemoteDatasource(dio: serviceLocator<Dio>()),
  );
  
  serviceLocator.registerFactory<CategoryRemoteDatasource>(
    () => CategoryRemoteDatasource(dio: serviceLocator<Dio>()),
  );

  // --- Property Repositories ---
  serviceLocator.registerFactory<IPropertyRepository>(
    () => PropertyRemoteRepository(
      remoteDataSource: serviceLocator<PropertyRemoteDatasource>(),
    ),
  );
  
  serviceLocator.registerFactory<ICategoryRepository>(
    () => CategoryRemoteRepository(
      remoteDataSource: serviceLocator<CategoryRemoteDatasource>(),
    ),
  );

  // --- Property Usecases ---
  serviceLocator.registerFactory<GetAllPropertiesUsecase>(
    () => GetAllPropertiesUsecase(
      serviceLocator<IPropertyRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<AddPropertyUsecase>(
    () => AddPropertyUsecase(
      repository: serviceLocator<IPropertyRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<GetAllCategoriesUsecase>(
    () => GetAllCategoriesUsecase(
      serviceLocator<ICategoryRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<AddCategoryUsecase>(
    () => AddCategoryUsecase(
      serviceLocator<ICategoryRepository>(),
    ),
  );

  // --- Property ViewModels/Blocs ---
  serviceLocator.registerFactory<AddPropertyBloc>(
    () => AddPropertyBloc(
      addPropertyUsecase: serviceLocator<AddPropertyUsecase>(),
      getAllCategoriesUsecase: serviceLocator<GetAllCategoriesUsecase>(),
      hiveService: serviceLocator<HiveService>(),
    ),
  );
}

void _initCartModules() {
  // --- Cart Data Sources ---
  serviceLocator.registerFactory<CartApiService>(
    () => CartApiServiceImpl(serviceLocator<ApiService>()),
  );

  // --- Cart Repositories ---
  serviceLocator.registerFactory<CartRepository>(
    () => CartRepositoryImpl(
      serviceLocator<CartApiService>(),
    ),
  );

  // --- Cart Usecases ---
  serviceLocator.registerFactory<GetCartUseCase>(
    () => GetCartUseCase(
      serviceLocator<CartRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<AddToCartUseCase>(
    () => AddToCartUseCase(
      serviceLocator<CartRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(
      serviceLocator<CartRepository>(),
    ),
  );
  
  serviceLocator.registerFactory<ClearCartUseCase>(
    () => ClearCartUseCase(
      serviceLocator<CartRepository>(),
    ),
  );

  // --- Cart Bloc ---
  serviceLocator.registerFactory<CartBloc>(
    () => CartBloc(
      getCartUseCase: serviceLocator<GetCartUseCase>(),
      addToCartUseCase: serviceLocator<AddToCartUseCase>(),
      removeFromCartUseCase: serviceLocator<RemoveFromCartUseCase>(),
      clearCartUseCase: serviceLocator<ClearCartUseCase>(),
    ),
  );
}

void _initAuthAndProfileModules() {
  // --- Data Sources ---
  serviceLocator.registerFactory<UserLocalDatasource>(
        () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory<UserRemoteDatasource>(
        () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // --- Repositories ---
  serviceLocator.registerFactory<UserLocalRepository>(
        () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );
  serviceLocator.registerFactory<UserRemoteRepository>(
        () => UserRemoteRepository(
      dataSource: serviceLocator<UserRemoteDatasource>(),
      hiveService: serviceLocator<HiveService>(),
    ),
  );

  // --- Repository Selection (Concrete Implementation for Interface) ---
  serviceLocator.registerFactory<IUserRepository>(
        () => serviceLocator<UserRemoteRepository>(),
  );

  // --- Usecases ---
  serviceLocator.registerFactory<UserLoginUsecase>(
        () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  serviceLocator.registerFactory<UserRegisterUsecase>(
        () => UserRegisterUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  serviceLocator.registerFactory<UserGetCurrentUsecase>(
        () => UserGetCurrentUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  serviceLocator.registerFactory<UploadProfilePictureUsecase>(
        () => UploadProfilePictureUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // --- ViewModels ---
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(
      loginUserUseCase: serviceLocator<UserLoginUsecase>(),
    ),
  );

  serviceLocator.registerFactory<RegisterUserViewModel>(
        () => RegisterUserViewModel(serviceLocator<UserRegisterUsecase>()),
  );

  serviceLocator.registerFactory<ProfileViewModel>(
        () => ProfileViewModel(
      userGetCurrentUsecase: serviceLocator<UserGetCurrentUsecase>(),
      uploadProfilePictureUsecase: serviceLocator<UploadProfilePictureUsecase>(),
      hiveService: serviceLocator<HiveService>(),
    ),
  );
}

void _initDashboardModules() {
  // --- Dashboard Data Sources ---
  serviceLocator.registerFactory<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(apiService: serviceLocator<ApiService>()),
  );

  // --- Dashboard Repositories ---
  serviceLocator.registerFactory<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDatasource: serviceLocator<DashboardRemoteDatasource>(),
    ),
  );

  // --- Dashboard Usecases ---
  serviceLocator.registerFactory<GetDashboardPropertiesUsecase>(
    () => GetDashboardPropertiesUsecase(
      repository: serviceLocator<DashboardRepository>(),
    ),
  );

  // --- Dashboard ViewModels/Blocs ---
  serviceLocator.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(
      getDashboardPropertiesUsecase: serviceLocator<GetDashboardPropertiesUsecase>(),
    ),
  );
}

void _initExploreModules() {
  // --- Explore Data Sources ---
  serviceLocator.registerFactory<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSourceImpl(
      serviceLocator<ApiService>(),
    ),
  );

  // --- Explore Repositories ---
  serviceLocator.registerFactory<ExploreRepository>(
    () => ExploreRepositoryImpl(
      serviceLocator<ExploreRemoteDataSource>(),
    ),
  );

  // --- Explore Usecases ---
  serviceLocator.registerFactory<GetExplorePropertiesUsecase>(
    () => GetExplorePropertiesUsecase(
      serviceLocator<ExploreRepository>(),
    ),
  );

  // --- Explore Bloc ---
  serviceLocator.registerFactory<ExploreBloc>(
    () => ExploreBloc(
      getAllPropertiesUsecase: serviceLocator<GetExplorePropertiesUsecase>(),
    ),
  );
}