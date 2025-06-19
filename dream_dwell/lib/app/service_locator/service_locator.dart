import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _registerCoreServices();
  await serviceLocator<HiveService>().init();

  // 3. Initialize feature-specific modules.
  _initAuthModule();


}

/// Registers core application services that are typically singletons.
void _registerCoreServices() {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<ApiService>(
        () => ApiService(serviceLocator<Dio>()),
  );
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

/// Initializes dependencies for the authentication module.
void _initAuthModule() {
  // Data Sources
  // UserLocalDatasource depends on HiveService to interact with local storage.
  serviceLocator.registerFactory<UserLocalDatasource>(
        () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  // If you had a remote data source, you'd register it here:
  // serviceLocator.registerFactory<UserRemoteDatasource>(
  //   () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  // );

  // Repositories
  // UserLocalRepository depends on UserLocalDatasource to handle data operations.
  serviceLocator.registerFactory<UserLocalRepository>(
        () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory<UserLoginUsecase>(
        () => UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  // UserRegisterUseCase also depends on a UserRepository.
  serviceLocator.registerFactory<UserRegisterUseCase>(
        () => UserRegisterUseCase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  // You would register other auth-related use cases (e.g., GetCurrentUserUsecase) here.

  // View Models
  // LoginViewModel depends on UserLoginUsecase to perform login logic.
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(loginUserUseCase: serviceLocator<UserLoginUsecase>()),
  );

  // RegisterUserViewModel depends on UserRegisterUseCase to handle registration.
  serviceLocator.registerFactory<RegisterUserViewModel>( // Correct class name
        () => RegisterUserViewModel(serviceLocator<UserRegisterUseCase>()),
  );
}