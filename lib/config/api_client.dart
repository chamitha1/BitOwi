import 'dart:ui';
import 'dart:convert';
import 'package:BitOwi/config/config.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/im_util.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';

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
            onResponse: (response, handler) async {
              // Decode if plain string
              if (response.data is String) {
                try {
                  response.data = json.decode(response.data);
                } catch (e) {
                  AppLogger.d('JSON decode error: $e');
                }
              }

              AppLogger.d("------------API Response------------");
              AppLogger.d("URI: ${response.requestOptions.uri}");
              AppLogger.d("HTTP Code: ${response.statusCode}");

              // ✅ If response.data is Map, safely read code/errorCode as String
              if (response.data is Map) {
                final map = response.data as Map;

                final code = (map['code'] ?? '').toString();          // <- important
                final errorCode = (map['errorCode'] ?? '').toString(); // <- important

                // ✅ Detect auth/session invalid (token revoked / logged in other device)
                final isAuthExpired = _isAuthError(errorCode, code) || code == '401';

                if (isAuthExpired) {
                  AppLogger.d("Auth expired detected. Logging out... code=$code errorCode=$errorCode");

                  await StorageService.removeToken();
                  await IMUtil.logoutIMUser();

                  if (Get.currentRoute != Routes.login) {
                    Get.offAllNamed(Routes.login);
                    Get.snackbar(
                      'Session Expired',
                      'You have been logged out because your account was used on another device.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }

                  return handler.reject(
                    DioException(
                      requestOptions: response.requestOptions,
                      error: "Session expired",
                      response: response,
                    ),
                  );
                }
              }

              // ✅ Normal success handling
              if (isSuccess(response)) {
                return handler.next(response);
              }

              // ❗ Non-success: reject with message
              final errorMsg = getErrorMsg(response);
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  error: errorMsg,
                  response: response,
                ),
              );
            },

            onError: (DioException e, handler) async {
              final statusCode = e.response?.statusCode;
              final data = e.response?.data;

              bool isSessionExpired = false;

              // 1) HTTP unauthorized
              if (statusCode == 401) {
                isSessionExpired = true;
              }

              // 2) Some APIs return 200 but include code inside body
              if (data is Map && (data['code'] == 401 || data['code'] == '401')) {
                isSessionExpired = true;
              }

              if (isSessionExpired) {
                // clear local session
                await StorageService.removeToken();
                await IMUtil.logoutIMUser();

                // avoid navigation loop
                if (Get.currentRoute != Routes.login) {
                  Get.offAllNamed(Routes.login);

                  // optional message
                  Get.snackbar(
                    'Session Expired',
                    'You have been logged out because your account was used on another device.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              }

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

bool isSuccess(Response<dynamic> response) {
  if (response.statusCode != 200) return false;
  if (response.data is! Map) return false;

  final code = (response.data['code'] ?? '').toString();
  return code == '200';
}

bool _isAuthError(String errorCode, String code) {
  if (code == '300' || code == '401') return true;

  switch (errorCode) {
    // token error
    case '300000':
    // token expires
    case '300001':
    // Token cannot be empty
    case '300002':
    // User authentication failed
    case 'A50004':
      return true;
    default:
      return false;
  }
}

String getErrorMsg(Response<dynamic> response) {
  if (response.statusCode != 200) {
    return "Network timeout, please try again";
  }
  String errorCode = response.data['errorCode'];
  String code = response.data['code'];
  if (_isAuthError(errorCode, code)) {
    StorageService.removeToken();
    IMUtil.logoutIMUser();
    Get.toNamed(Routes.login);
    // EventBusUtil.fireUserLogout();
    return "Your login has expired, please log in again";
  }
  return response.data['errorMsg'] ?? "Network timeout, please try again";
}
