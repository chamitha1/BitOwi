import 'dart:convert';
import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/auth/presentation/pages/login_screen.dart';
import 'package:BitOwi/models/api_result.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:BitOwi/models/user_model.dart';
import 'package:BitOwi/models/user_relation_page_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:BitOwi/constants/sms_constants.dart';

class UserApi {
  //Login API
  Future<LoginScreen> login({
    required String loginName,
    required String loginPwd,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/cuser/public/login',
        data: {'loginName': loginName, 'loginPwd': loginPwd},
      );
      return response.data;
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  //Sign up API
  Future<Map<String, dynamic>> signup({
    required String email,
    required String smsCode,
    required String loginPwd,
    String? inviteCode,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'smsCode': smsCode,
        'loginPwd': loginPwd,
      };

      if (inviteCode != null && inviteCode.isNotEmpty) {
        data['inviteCode'] = inviteCode;
      }

      final response = await ApiClient.dio.post(
        '/core/v1/cuser/public/register_by_email',
        data: data,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e(e);
      rethrow;
    }
  }

  //Send OTP API
  Future<bool> sendOtp({
    required String email,
    SmsBizType bizType = SmsBizType.register,
  }) async {
    try {
      final reqData = {'email': email, 'bizType': bizType.value};
      AppLogger.d("Send OTP Request: $reqData");

      final response = await ApiClient.dio.post(
        '/core/v1/sms_out/permission_none/email_code',
        data: reqData,
      );
      AppLogger.d("Send OTP Response: ${response.data}");

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = response.data as Map<String, dynamic>;
      } else if (response.data is String) {
        try {
          AppLogger.d("Response data is String, parsing...");

          return false;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }

      if (data['code'] == 200 ||
          data['code'] == '200' ||
          data['errorCode'] == 'Success' ||
          data['errorCode'] == 'SUCCESS') {
        return true;
      }
      // Default fallback
      return false;
    } on DioException catch (e) {
      AppLogger.e(e);
      AppLogger.d('Send OTP Dio error: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      AppLogger.d('Send OTP unexpected error: $e');
      return false;
    }
  }

  Future<ApiResult> sendSignInOtp({
    required String email,
    SmsBizType bizType = SmsBizType.register,
  }) async {
    try {
      final reqData = {'email': email, 'bizType': bizType.value};

      final response = await ApiClient.dio.post(
        '/core/v1/sms_out/permission_none/email_code',
        data: reqData,
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (data['code'] == 200 ||
            data['code'] == '200' ||
            data['errorCode'] == 'Success' ||
            data['errorCode'] == 'SUCCESS') {
          return ApiResult(success: true);
        }

        // ❗ Backend logical error (like AUTH00006)
        return ApiResult(
          success: false,
          message: data['errorMsg'] ?? 'Failed to send OTP',
        );
      }

      return ApiResult(success: false, message: 'Invalid server response');
    } on DioException catch (e) {
      final data = e.response?.data;
      return ApiResult(
        success: false,
        message: data is Map ? data['errorMsg'] : e.message,
      );
    } catch (e) {
      return ApiResult(success: false, message: 'Unexpected error occurred');
    }
  }

  // Verify OTP
  /* 
curl -i -X POST "BASE_URL/core/v1/otp/verify_public" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sachi@gmail.com",
    "bizType": "C_REG_EMAIL",
    "otp": "000000"
  }'

for register and forgetPwd
  */
  Future<Map<String, dynamic>> verifyOtpPublic({
    required String email,
    required String otp,
    SmsBizType bizType = SmsBizType.register,
  }) async {
    try {
      String url = '/core/v1/otp/permission_none/verify_public';
      Options? options;
      // Switch to public endpoint for Register and Forgot Password
      if (bizType == SmsBizType.register || bizType == SmsBizType.forgetPwd) {
        url = '/core/v1/otp/verify_public';

        // 🚀 CRITICAL FIX: Use a NEW Dio instance to BYPASS global ApiClient interceptors.
        // The global interceptor logs out on code 300/300000, which this endpoint might return.
        final publicDio = Dio(
          BaseOptions(
            baseUrl: ApiClient.dio.options.baseUrl,
            headers: {'Content-Type': 'application/json', 'Authorization': ''},
            responseType: ResponseType.plain,
            validateStatus: (status) => true,
          ),
        );
        final reqData = {'email': email, 'bizType': bizType.value, 'otp': otp};
        final response = await publicDio.post(url, data: reqData);

        AppLogger.d("URL :  $url");
        AppLogger.d("Req Data :  $reqData");

        // Manual parsing
        Map<String, dynamic> data;
        if (response.data is String) {
          try {
            data = json.decode(response.data) as Map<String, dynamic>;
          } catch (e) {
            data = {};
          }
        } else {
          data = response.data as Map<String, dynamic>;
        }
        AppLogger.d("Verify OTP Public Response: $data");
        return data;
      }

      final response = await ApiClient.dio.post(
        url,
        data: {'email': email, 'bizType': bizType.value, 'otp': otp},
      );
      AppLogger.d("Verify OTP Response: ${response.data}");

      return response.data as Map<String, dynamic>;
      // return response.data;
    } catch (e) {
      AppLogger.d('Verify OTP error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /*curl -i -X POST "BASE_URL/core/v1/otp/verify" \
  -H "Authorization: TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sachi@gmail.com",
    "bizType": "C_REG_EMAIL",
    "otp": "000000"
  }'

for resetLoginPwd, bindTradePwd, modifyEmail, openGoogle, closeGoogle, withdraw */
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    SmsBizType bizType = SmsBizType.register,
  }) async {
    try {
      String? token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        return {'success': false, 'error': 'No auth token found'};
      }

      AppLogger.d("Manual Token for Verify: $token");

      final freshDio = Dio(
        BaseOptions(
          baseUrl: ApiClient.dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          headers: {
            'Content-Type': 'application/json',
            'Accept-Language': 'en_US',
            'Authorization': token,
          },
          responseType: ResponseType.plain,
          validateStatus: (status) => true,
        ),
      );

      final reqData = {'email': email, 'bizType': bizType.value, 'otp': otp};
      AppLogger.d("Request Data $reqData");
      final response = await freshDio.post(
        '/core/v1/otp/verify',
        data: {'email': email, 'bizType': bizType.value, 'otp': otp},
      );

      AppLogger.d("Verify OTP Raw Response: ${response.data}");

      Map<String, dynamic> data;
      if (response.data is String) {
        try {
          data = json.decode(response.data);
        } catch (e) {
          return {'success': false, 'error': response.data};
        }
      } else {
        data = response.data as Map<String, dynamic>;
      }

      final code = (data['code'] ?? '').toString();
      final errorCode = (data['errorCode'] ?? '').toString();

      if (code == '300' || errorCode == '300003') {
        AppLogger.d("Server reported session expired, caught it manually.");
        return {
          'success': false,
          'code': 300003,
          'msg': 'Session expired. Please login again.',
        };
      }

      return data;
    } catch (e) {
      AppLogger.d('Verify OTP error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Bind Trade Password
  Future<Map<String, dynamic>> bindTradePwd({
    required String email,
    required String smsCode,
    required String tradePwd,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/user/bind_tradePwd',
        data: {'email': email, 'smsCaptcha': smsCode, 'tradePwd': tradePwd},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.d("Bind Trade Password error: $e");
      rethrow;
    }
  }

  /// Get User Info
  static Future<User> getUserInfo() async {
    try {
      final response = await ApiClient.dio.post("/core/v1/cuser/my");
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['code'] == 200 || responseData['code'] == '200') {
        final userData = responseData['data'] as Map<String, dynamic>;
        if (userData['nickname'] != null) {
          userData['nickname'] = userData['nickname'].toString();
        }
        return User.fromJson(userData);
      }
      throw Exception(responseData['errorMsg'] ?? 'Unknown error');
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  /// Modify user information
  static Future<void> modifyUser(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        "/core/v1/user/edit_profile",
        data: data,
      );
      final resData = response.data;
      if (resData is Map &&
          resData['code'] != 200 &&
          resData['code'] != '200') {
        throw Exception(resData['errorMsg'] ?? 'Update failed');
      }
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  // Log Out
  static Future<void> logOff() async {
    try {
      final response = await ApiClient.dio.get("/core/v1/cuser/logOut");
      AppLogger.d("Logout Response: ${response.data}");
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  /// Real name authentication (USER KYC)
  static Future<ApiResult> createIdentifyOrder(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/identify_order/create",
        data: data,
      );
      if (res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;

        if (data['code'] == 200 ||
            data['code'] == '200' ||
            data['errorCode'] == 'Success' ||
            data['errorCode'] == 'SUCCESS') {
          return ApiResult(success: true);
        }

        // ❗ Backend logical error (like AUTH00006)
        return ApiResult(
          success: false,
          message: data['errorMsg'] ?? 'Something went wrong',
        );
      }
      return ApiResult(success: false, message: 'Invalid server response');
    } on DioException catch (e) {
      // like 500 error
      final data = e.response?.data;
      return ApiResult(
        success: false,
        message: data is Map ? data['errorMsg'] : e.message,
      );
    } catch (e) {
      return ApiResult(success: false, message: 'Unexpected error occurred');
    }
  }

  /// Get User KYC requests status
  static Future<List<IdentifyOrderListRes>> getIdentifyOrderList() async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/identify_order/list_front',
        data: {},
      );
      final List<dynamic> data = res.data['data'] as List<dynamic>;
      List<IdentifyOrderListRes> list = data
          .map((item) => IdentifyOrderListRes.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  /// Add merchant certification
  static Future<void> createMerchantOrder() async {
    try {
      await ApiClient.dio.post("/core/v1/merchant_record/create");
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  /// Remove merchant certification
  // static Future<Map<String, dynamic>> removeMerchantOrder() async {
  static Future<ApiResult> removeMerchantOrder() async {
    try {
      final res = await ApiClient.dio.post("/core/v1/merchant_record/reliever");

      if (res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;

        if (data['code'] == 200 ||
            data['code'] == '200' ||
            data['errorCode'] == 'Success' ||
            data['errorCode'] == 'SUCCESS') {
          return ApiResult(success: true);
        }

        // ❗ Backend logical error (like AUTH00006)
        return ApiResult(
          success: false,
          message: data['errorMsg'] ?? 'Something went wrong',
        );
      }
      return ApiResult(success: false, message: 'Invalid server response');
    } on DioException catch (e) {
      // like 500 error
      final data = e.response?.data;
      return ApiResult(
        success: false,
        message: data is Map ? data['errorMsg'] : e.message,
      );
    } catch (e) {
      return ApiResult(success: false, message: 'Unexpected error occurred');
    }
  }

  // Forget Login Password
  static Future<void> forgetLoginPwd({
    required String email,
    required String smsCaptcha,
    required String loginPwd,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/user/public/forget_loginPwd_by_email",
        data: {
          "email": email,
          "smsCaptcha": smsCaptcha,
          "loginPwd": loginPwd,
          "userKind": "C",
        },
      );
      AppLogger.d("Forget Login Password Response: ${res.data}");
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  // Modify Email
  Future<Map<String, dynamic>> modifyEmail({
    required String newEmail,
    required String smsCaptchaOld,
    required String smsCaptchaNew,
  }) async {
    try {
      final data = {
        'newEmail': newEmail,
        'smsCaptchaOld': smsCaptchaOld,
        'smsCaptchaNew': smsCaptchaNew,
      };

      // Print as Map (default toString)

      // Print as formatted JSON
      try {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        AppLogger.d(encoder.convert(data));
      } catch (e) {
        AppLogger.d("Error printing JSON: $e");
      }

      final response = await ApiClient.dio.post(
        '/core/v1/user/modify_email',
        data: data,
      );
      AppLogger.d("Modify Email Response: ${response.data}");
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.d("Modify Email error: $e");
      rethrow;
    }
  }

  // Get Google Secret
  static Future<String> getGoogleSecret() async {
    try {
      final response = await ApiClient.dio.post(
        "/core/v1/user/get_google_secret",
      );
      final data = response.data;
      if (data['code'] == 200 || data['code'] == '200') {
        return data['data']['googleSecret'];
      }
      throw Exception(data['errorMsg'] ?? 'Failed to get google secret');
    } catch (e) {
      AppLogger.d("Get Google Secret error: $e");
      rethrow;
    }
  }

  // Bind Google Secret
  static Future<void> bindGoogleSecret({
    required String googleCaptcha,
    required String secret,
    required String smsCaptcha,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/user/bind_google_secret',
        data: {
          'googleCaptcha': googleCaptcha,
          'secret': secret,
          'smsCaptcha': smsCaptcha,
        },
      );
      final data = response.data;
      if (data['code'] != 200 && data['code'] != '200') {
        throw Exception(data['errorMsg'] ?? 'Failed to bind google secret');
      }
    } catch (e) {
      AppLogger.d("Bind Google Secret error: $e");
      rethrow;
    }
  }

  // Close Google Secret
  static Future<void> closeGoogleSecret({
    required String googleCaptcha,
    required String smsCaptcha,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/user/close_google_secret',
        data: {'googleCaptcha': googleCaptcha, 'smsCaptcha': smsCaptcha},
      );
      AppLogger.d("Close Google Secret Response: ${response.data}");
      final data = response.data;
      if (data['code'] != 200 && data['code'] != '200') {
        throw Exception(data['errorMsg'] ?? 'Failed to close google secret');
      }
    } catch (e) {
      AppLogger.d("Close Google Secret error: $e");
      rethrow;
    }
  }

  /// Get User Relation Page List (Partners)
  static Future<PageInfo<UserRelationPageRes>> getUserRelationPageList(
    Map<String, dynamic> data,
  ) async {
    try {
      AppLogger.d("getUserRelationPageList Request: $data");
      final res = await ApiClient.dio.post(
        '/core/v1/user_relation/page_front',
        data: data,
      );
      AppLogger.d("getUserRelationPageList Response: ${res.data}");

      final responseData = res.data as Map<String, dynamic>;
      if (responseData['code'] == 200 || responseData['code'] == '200') {
        return PageInfo<UserRelationPageRes>.fromJson(
          responseData,
          (json) => UserRelationPageRes.fromJson(json),
        );
      } else {
        throw Exception(
          responseData['errorMsg'] ?? 'Failed to get partner list',
        );
      }
    } catch (e) {
      AppLogger.d('getUserRelationPageList Error: $e');
      rethrow;
    }
  }

  /// Create User Relation (Trust or Block)
  /// type: 0 = Blacklist/Block, 1 = Trust
  static Future<void> createUserRelation({
    required String toUser,
    required String type,
  }) async {
    try {
      AppLogger.d("createUserRelation Request: {toUser: $toUser, type: $type}");
      await ApiClient.dio.post(
        "/core/v1/user_relation/create",
        data: {"toUser": toUser, "type": type},
      );
      AppLogger.d("createUserRelation Response: Success");
    } catch (e) {
      AppLogger.d("createUserRelation error: $e");
      rethrow;
    }
  }

  /// Remove User Relation (Untrust or Unblock)
  /// type: 0 = Blacklist/Block, 1 = Trust
  static Future<void> removeUserRelation({
    required String toUser,
    required String type,
  }) async {
    try {
      AppLogger.d("removeUserRelation Request: {toUser: $toUser, type: $type}");
      await ApiClient.dio.post(
        "/core/v1/user_relation/modify",
        data: {"toUser": toUser, "type": type},
      );
      AppLogger.d("removeUserRelation Response: Success");
    } catch (e) {
      AppLogger.d("removeUserRelation error: $e");
      rethrow;
    }
  }
}
