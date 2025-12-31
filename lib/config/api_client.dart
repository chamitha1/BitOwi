import 'dart:ui';
import 'package:BitOwi/config/config.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.apiUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await _getToken();

              // ✅ FIXED: Only add Authorization header if token exists
              if (token != null && token.isNotEmpty && token != ' ') {
                options.headers['Authorization'] = token;
                print("Token being sent: '$token'");
              } else {
                print("No valid token found, skipping Authorization header");
              }

              options.headers.addAll({
                // 'Authorization': authHeader,
                'content-Type': 'application/json',
                // 'Accept-Language': Get.deviceLocale?.toString() ?? 'en_US',
                'Accept-Language': Get.deviceLocale?.toString() == 'en_GB'
                    ? const Locale('en', 'US')
                    : Get.deviceLocale,
                // 'Accept-Language': 'en_US',
              });

              print("------------API Request------------");
              print("URI: ${options.uri}");
              print("Token being sent from storage: '$token'");

              return handler.next(options);
            },
            onResponse: (response, handler) {
              print("------------API Response------------");
              print("URI: ${response.requestOptions.uri}");
              print("Code: ${response.statusCode}");
              return handler.next(response);
            },
            onError: (DioException e, handler) {
              print("------------API Error------------");
              print("URI: ${e.requestOptions.uri}");
              print("Msg: ${e.message}");
              return handler.next(e);
            },
          ),
        );

  static Future<String?> _getToken() async {
    try {
      return await StorageService.getToken();
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }
}
