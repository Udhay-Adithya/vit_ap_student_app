import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio dio;

  DioClient({Dio? dio}) : dio = dio ?? Dio() {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.options.baseUrl = 'https://vit-ap.fly.dev/'; // Your base URL
    dio.options.headers['API-KEY'] = dotenv.env['API_KEY'];

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any request preprocessing if needed
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Add any response preprocessing if needed
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Add custom error handling
        return handler.next(e);
      },
    ));
  }
}
