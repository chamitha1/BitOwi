import 'package:BitDo/config/config.dart';
import 'package:BitDo/core/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl, 
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        
        final authHeader = (token != null && token.isNotEmpty) ? token : " ";
        
        options.headers.addAll({
          'Authorization': authHeader,
          'content-Type': 'application/json',
          'Accept-Language': Get.deviceLocale?.toString() ?? 'en_US', 
        });

        print("------------API Request------------");
        print("URI: ${options.uri}");
        print("Token being sent: '$authHeader'");
        
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
