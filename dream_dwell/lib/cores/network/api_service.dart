
import 'package:dio/dio.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/cores/network/dio_error_interceptor.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


class ApiService {
  final Dio _dio;
  final HiveService _hiveService;

  Dio get dio => _dio;

  ApiService(this._dio, this._hiveService) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) async {
            print('API Request: ${options.method} ${options.path}');
            final token = await _hiveService.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              print('API Request: Token attached');
            } else {
              print('API Request: No token available');
            }

            if (options.data is! FormData) {
              options.headers['Content-Type'] = 'application/json';
            }
            options.headers['Accept'] = 'application/json';

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('API Response: ${response.statusCode} ${response.requestOptions.path}');
            return handler.next(response);
          },
          onError: (error, handler) async {
            print('API Error: ${error.response?.statusCode} ${error.requestOptions.path} - ${error.message}');
            if (error.response?.statusCode == 401) {
              print('401 Unauthorized: Attempting to clear token and log out.');
              await _hiveService.deleteToken();
            }
            return handler.next(error);
          },
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          compact: true,
        ),
      );
  }
}
