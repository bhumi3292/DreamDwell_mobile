import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

// Auth
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  _initApiService();
  _initAuthModule();
}

Future<void> _initHiveService() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

void _initApiService() {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<ApiService>(
        () => ApiService(serviceLocator<Dio>()),
  );
}

void _initAuthModule() {
  // Data Source
  serviceLocator.registerFactory<UserLocalDatasource>(
        () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  // Repository
  serviceLocator.registerFactory<UserLocalRepository>(
        () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory<UserLoginUsecase>(
        () => UserLoginUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory<UserRegisterUsecase>(
        () => UserRegisterUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  // ViewModels
  serviceLocator.registerFactory<LoginViewModel>(
        () => LoginViewModel(
      loginUserUseCase: serviceLocator<UserLoginUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
        () => RegisterUserViewModel(serviceLocator<UserRegisterUsecase>()),
  );

}
