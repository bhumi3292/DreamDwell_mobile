import 'package:dream_dwell/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/remote_repository/register_remote_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

// Auth
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';

import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;


Future<void> initDependencies() async {
  // Initialize HiveService first as it's a core dependency
  await _initHiveService();
  // Initialize ApiService which depends on Dio and HiveService
  _initApiService();
  // Initialize authentication-related modules
  _initAuthModule();
}

/// Initializes and registers the [HiveService] as a singleton.
Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init(); // Ensure Hive is initialized before registration
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

/// Initializes and registers [Dio] and [ApiService].
void _initApiService() {
  // Register Dio as a lazy singleton, creating it only when first accessed
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  // Register ApiService as a lazy singleton, injecting Dio and HiveService
  serviceLocator.registerLazySingleton<ApiService>(
        () => ApiService(
      serviceLocator<Dio>(),
      serviceLocator<HiveService>(),
    ),
  );
}

void _initAuthModule() {
  // --- Data Sources ---
  // Register UserLocalDatasource, depends on HiveService
  serviceLocator.registerFactory<UserLocalDatasource>(
        () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  // Register UserRemoteDatasource, depends on ApiService
  serviceLocator.registerFactory<UserRemoteDatasource>(
        () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // --- Repositories ---
  // Register UserLocalRepository, depends on UserLocalDatasource
  serviceLocator.registerFactory<UserLocalRepository>(
        () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );
  // Register UserRemoteRepository, depends on UserRemoteDatasource
  serviceLocator.registerFactory<UserRemoteRepository>(
        () => UserRemoteRepository(
      dataSource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // --- Repository Selection ---
  // Register the concrete implementation for the IUserRepository interface.
  // Here, we are choosing to use the UserRemoteRepository.
  serviceLocator.registerFactory<IUserRepository>(
        () => serviceLocator<UserRemoteRepository>(),
  );

  // --- Usecases ---
  // Register UserLoginUsecase, depends on IUserRepository
  serviceLocator.registerFactory<UserLoginUsecase>(
        () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  // Register UserRegisterUsecase, depends on IUserRepository
  serviceLocator.registerFactory<UserRegisterUsecase>(
        () => UserRegisterUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // --- ViewModels ---
  // Register LoginViewModel, depends on UserLoginUsecase
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(
      loginUserUseCase: serviceLocator<UserLoginUsecase>(),
    ),
  );
  // Register RegisterUserViewModel, depends on UserRegisterUsecase
  serviceLocator.registerFactory<RegisterUserViewModel>(
        () => RegisterUserViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}