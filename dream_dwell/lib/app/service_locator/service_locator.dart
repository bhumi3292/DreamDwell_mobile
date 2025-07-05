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
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Profile
import 'package:dream_dwell/features/profile/domain/use_case/upload_profile_picture_usecase.dart'; // ⭐ NEW: Import UploadProfilePictureUsecase ⭐
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';




final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiService();
  _initAuthAndProfileModules();
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
  // ⭐ CORE FIX: Provide 'hiveService' to UserRemoteRepository here ⭐
  serviceLocator.registerFactory<UserRemoteRepository>(
        () => UserRemoteRepository(
      dataSource: serviceLocator<UserRemoteDatasource>(),
      hiveService: serviceLocator<HiveService>(), // ⭐ ADD THIS LINE ⭐
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