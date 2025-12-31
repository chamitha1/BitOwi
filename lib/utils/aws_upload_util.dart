import 'package:BitOwi/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:wallet/utils/http_util.dart';

typedef OnProgressCallback = void Function(int count, int data);

class AwsUploadUtil {
  AwsUploadUtil._internal();

  static final AwsUploadUtil _singleton = AwsUploadUtil._internal();

  factory AwsUploadUtil() => _singleton;

  /// Get upload parameters
  Future<FormData> getUploadParams(XFile xfile) async {
    MultipartFile file;
    if (kIsWeb) {
      file = MultipartFile.fromBytes(
        await xfile.readAsBytes(),
        filename: xfile.name,
      );
    } else {
      file = await MultipartFile.fromFile(xfile.path, filename: xfile.name);
    }

    // form object of request parameters
    FormData data = FormData.fromMap({
      'contentType': 'multipart/form-data',
      'file': file,
    });
    return data;
  }

  /// Image upload
  Future<String> upload({
    required XFile file,
    OnProgressCallback? onSendProgress,
  }) async {
    FormData data = await getUploadParams(file);

    BaseOptions options = BaseOptions();
    Dio dio = Dio(options);

    try {
      String baseUrl = kIsWeb ? AppConfig.webApiUrl : AppConfig.apiUrl;

      final response = await dio.post(
        '$baseUrl/core/v1/file/public/upload',
        // '$baseUrl/file/public/upload',
        data: data,
        onSendProgress: (int count, int data) {
          if (onSendProgress != null) {
            onSendProgress(count, data);
          }
        },
      );
      // if (isSuccess(response)) {
      // return response.data["data"]["imageUrl"];
      // }
      // String errorMsg = getErrorMsg(response);
      // throw DioError(requestOptions: response.requestOptions, error: errorMsg);

      // ---------- RESPONSE VALIDATION ----------
      final resData = response.data;
      if (resData == null || resData is! Map) {
        throw Exception('Invalid server response');
      }
      // BACKEND-SAFE PARSING
      final String code = resData['code']?.toString() ?? '';
      final String errorMsg =
          resData['errorMsg']?.toString() ?? 'Upload failed';

      if (code != '200') {
        throw Exception(errorMsg);
      }
      final imageUrl = resData['data']?['imageUrl'];
      if (imageUrl == null || imageUrl.toString().isEmpty) {
        throw Exception('Image URL not found');
      }
      return imageUrl.toString();
    }
    // ---------- DIO ERRORS ----------
    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Network timeout, please try again');
      }
      if (e.response != null) {
        final msg = e.response?.data?['msg'] ?? 'Upload failed';
        throw Exception(msg);
      }
      throw Exception('Network error, please check your connection');
    }
    // ---------- UNKNOWN ERRORS ----------
    catch (e) {
      throw Exception(e.toString());
    }
  }
}

final awsUploadUtil = AwsUploadUtil();
