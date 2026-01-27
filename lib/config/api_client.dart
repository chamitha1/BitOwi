import 'dart:ui';
import 'dart:convert';
import 'package:BitOwi/config/config.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/utils/app_logger.dart';
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
            responseType: ResponseType.plain,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await _getToken();

              if (token != null && token.isNotEmpty && token != ' ') {
                options.headers['Authorization'] = token;
                AppLogger.d("Token being sent: '$token'");
              } else {
                AppLogger.d(
                  "No valid token found, skipping Authorization header",
                );
              }

              options.headers.addAll({
                // 'Authorization': authHeader,
                // 'content-Type': 'application/json',
                // 'Accept-Language': Get.deviceLocale?.toString() ?? 'en_US',
                'Accept-Language': 'en_US',
              });

              AppLogger.d("------------API Request------------");
              AppLogger.d("URI: ${options.uri}");
              AppLogger.d("Token being sent from storage: '$token'");

              return handler.next(options);
            },
            onResponse: (response, handler) {
              if (response.data is String) {
                try {
                  response.data = json.decode(response.data);
                } catch (e) {
                  AppLogger.d('JSON decode error: $e');
                }
              }

              AppLogger.d("------------API Response------------");
              AppLogger.d("URI: ${response.requestOptions.uri}");
              AppLogger.d("Code: ${response.statusCode}");
              return handler.next(response);
            },
            onError: (DioException e, handler) {
              AppLogger.d("------------API Error------------");
              AppLogger.d("URI: ${e.requestOptions.uri}");
              AppLogger.d("Msg: ${e.message}");
              return handler.next(e);
            },
          ),
        );

  static Future<String?> _getToken() async {
    try {
      return await StorageService.getToken();
    } catch (e) {
      AppLogger.d('Error getting token: $e');
      return null;
    }
  }
}
