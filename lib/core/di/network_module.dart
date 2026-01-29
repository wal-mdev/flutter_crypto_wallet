import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkModule {
  static Dio provideDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.coingecko.com/api/v3',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }

    return dio;
  }
}
