import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;
      if (statusCode >= 300) {
        // Attempt to get message from response data, fallback to status message
        errorMessage = err.response?.data['message']?.toString() ??
            err.response?.statusMessage ??
            'Unknown error';
      } else {
        errorMessage = 'Something went wrong';
      }
    } else {
      errorMessage = 'Connection error. Check your internet connection.'; // More specific error
    }

    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: errorMessage, // Set the custom error message
      type: err.type,
    );

    super.onError(customError, handler);
  }
}