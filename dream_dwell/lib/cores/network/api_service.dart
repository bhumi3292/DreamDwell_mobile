import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// These are imports from your project structure
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/cores/network/dio_error_interceptor.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

class ApiService {
  final Dio _dio;
  // This is the dependency responsible for securely storing and retrieving
  // data locally, including the authentication token.
  final HiveService _hiveService;

  Dio get dio => _dio;


  ApiService(this._dio, this._hiveService) {
    _dio
    // Set the base URL for all requests, connection timeout, and receive timeout.
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
    // Add `DioErrorInterceptor` first to handle and standardize API errors.
      ..interceptors.add(DioErrorInterceptor())
    // Add a `QueuedInterceptorsWrapper` to manage asynchronous operations
    // before a request, specifically for adding the authentication token.
      ..interceptors.add(
        QueuedInterceptorsWrapper(
          // `onRequest` is called before the HTTP request is sent.
          onRequest: (options, handler) async {
            // Attempt to retrieve the authentication token from `HiveService`.
            final token = await _hiveService.getToken();

            // If a token is available and not empty, add it to the
            // `Authorization` header in the "Bearer" format.
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            // Continue the request chain.
            return handler.next(options);
          },
          // `onResponse` is called when a response is received successfully.
          onResponse: (response, handler) {
            // You can add global response processing here if needed.
            return handler.next(response); // Continue processing the response.
          },
          // `onError` is called if an error occurs during the request.
          // `DioErrorInterceptor` handles the primary error messaging,
          // so this might not require additional logic unless for specific error flows.
          onError: (error, handler) {
            return handler.next(error); // Continue processing the error.
          },
        ),
      )
    // Add `PrettyDioLogger` last in the interceptor chain.
    // This ensures that it logs the request *after* all other interceptors
    // (like the token injector) have processed it, and logs the final response.
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,  // Logs request headers.
          requestBody: true,    // Logs request body (payload).
          responseHeader: true, // Logs response headers.
          responseBody: true,   // Logs response body.
        ),
      )
    // Set default headers for all outgoing requests.
      ..options.headers = {
        'Accept': 'application/json',     // Indicates client can accept JSON responses.
        'Content-Type': 'application/json', // Indicates client is sending JSON data.
      };
  }
}
