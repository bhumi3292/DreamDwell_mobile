import 'package:flutter/material.dart'; // Keep if BuildContext is used for factory
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
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart'; // NEW
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Profile
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart'; // NEW

final serviceLocator = GetIt.instance;

/// Initializes all application dependencies.
Future<void> initDependencies() async {
  // Initialize HiveService first as it's a core dependency
  await _initHiveService();
  // Initialize ApiService which depends on Dio and HiveService
  _initApiService();
  // Initialize authentication and profile related modules
  _initAuthAndProfileModules();
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

/// Initializes and registers all authentication and profile-related dependencies.
void _initAuthAndProfileModules() {
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
  // Assuming 'RegisterRemoteRepository' is actually 'UserRemoteRepository'
  serviceLocator.registerFactory<UserRemoteRepository>(
        () => UserRemoteRepository(
      dataSource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // --- Repository Selection (Concrete Implementation for Interface) ---
  // Here, we are choosing to use the UserRemoteRepository as the primary
  // implementation for IUserRepository.
  serviceLocator.registerFactory<IUserRepository>(
        () => serviceLocator<UserRemoteRepository>(),
  );

  // --- Usecases ---
  // User Login Usecase
  serviceLocator.registerFactory<UserLoginUsecase>(
        () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  // User Register Usecase
  serviceLocator.registerFactory<UserRegisterUsecase>(
        () => UserRegisterUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );
  // User Get Current Usecase (NEW)
  serviceLocator.registerFactory<UserGetCurrentUsecase>(
        () => UserGetCurrentUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // --- ViewModels ---
  // Login ViewModel
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(
      loginUserUseCase: serviceLocator<UserLoginUsecase>(),
    ),
  );
  // Register ViewModel
  serviceLocator.registerFactory<RegisterUserViewModel>(
        () => RegisterUserViewModel(serviceLocator<UserRegisterUsecase>()),
  );
  // Profile ViewModel (NEW)
  serviceLocator.registerFactory<ProfileViewModel>(
        () => ProfileViewModel(
      userGetCurrentUsecase: serviceLocator<UserGetCurrentUsecase>(),
      hiveService: serviceLocator<HiveService>(),
    ),
  );
}