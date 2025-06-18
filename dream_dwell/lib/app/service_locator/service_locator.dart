import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart';
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:dream_dwell/features/auth/data/repository/remote_repository/register_remote_repository.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initCoreModules();
  _initAuthModule();
}

void _initCoreModules() {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<ApiService>(
        () => ApiService(serviceLocator<Dio>()),
  );
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

void _initAuthModule() {
  // Register IUserDataSource as UserLocalDatasource
  serviceLocator.registerFactory(
        () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  // Register IUserRepository as UserLocalRepository
  serviceLocator.registerFactory(
        () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  // Register UserLoginUsecase
  serviceLocator.registerFactory(
        () => UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  // Register LoginViewModel
  serviceLocator.registerFactory(
        () => LoginViewModel(loginUserUseCase: serviceLocator<UserLoginUsecase>()),
  );
}

