import 'dart:convert';
import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/features/auth/presentation/pages/login_screen.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:BitOwi/models/user_model.dart';
import 'package:BitOwi/models/user_relation_page_res.dart';
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
      print(e);
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
      print("Send OTP Request: $reqData");

      final response = await ApiClient.dio.post(
        '/core/v1/sms_out/permission_none/email_code',
        data: reqData,
      );
      print("Send OTP Response: ${response.data}");

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = response.data as Map<String, dynamic>;
      } else if (response.data is String) {
        try {
          print("Response data is String, parsing...");

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
      print(e);
      print('Send OTP Dio error: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      print('Send OTP unexpected error: $e');
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp({
    required String email,
    required String otp,
    SmsBizType bizType = SmsBizType.register,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '',
        data: {'email': email, 'otp': otp, 'bizType': bizType.value},
      );

      // Check if OTP is valid
      return response.data;
    } catch (e) {
      print('Verify OTP error: $e');
      return false;
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
      print("Bind Trade Password error: $e");
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
      await ApiClient.dio.post("/core/v1/user/edit_profile", data: data);
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  // Log Out
  static Future<void> logOff() async {
    try {
      final response = await ApiClient.dio.get("/core/v1/cuser/logOut");
      print("Logout Response: ${response.data}");
    } catch (e) {
      e.printError();
      rethrow;
    }
  }

  /// Real name authentication (USER KYC)
  static Future<Map<String, dynamic>> createIdentifyOrder(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/identify_order/create",
        data: data,
      );
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      e.printError();
      rethrow;
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
  static Future<Map<String, dynamic>> removeMerchantOrder() async {
    try {
      final res = await ApiClient.dio.post("/core/v1/merchant_record/reliever");
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      e.printError();
      rethrow;
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
      print("Forget Login Password Response: ${res.data}");
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
      print(data);

      // Print as formatted JSON
      try {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        print(encoder.convert(data));
      } catch (e) {
        print("Error printing JSON: $e");
      }

      final response = await ApiClient.dio.post(
        '/core/v1/user/modify_email',
        data: data,
      );
      print("Modify Email Response: ${response.data}");
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print("Modify Email error: $e");
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
      print("Get Google Secret error: $e");
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
      print("Bind Google Secret Response: ${response.data}");
      final data = response.data;
      if (data['code'] != 200 && data['code'] != '200') {
        throw Exception(data['errorMsg'] ?? 'Failed to bind google secret');
      }
    } catch (e) {
      print("Bind Google Secret error: $e");
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
      print("Close Google Secret Response: ${response.data}");
      final data = response.data;
      if (data['code'] != 200 && data['code'] != '200') {
        throw Exception(data['errorMsg'] ?? 'Failed to close google secret');
      }
    } catch (e) {
      print("Close Google Secret error: $e");
      rethrow;
    }
  }

  /// Get User Relation Page List (Partners)
  static Future<PageInfo<UserRelationPageRes>> getUserRelationPageList(
    Map<String, dynamic> data,
  ) async {
    try {
      print("getUserRelationPageList Request: $data");
      final res = await ApiClient.dio.post(
        '/core/v1/user_relation/page_front',
        data: data,
      );
      print("getUserRelationPageList Response: ${res.data}");

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
      print('getUserRelationPageList Error: $e');
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
      await ApiClient.dio.post(
        "/core/v1/user_relation/create",
        data: {"toUser": toUser, "type": type},
      );
    } catch (e) {
      print("createUserRelation error: $e");
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
      await ApiClient.dio.post(
        "/core/v1/user_relation/modify",
        data: {"toUser": toUser, "type": type},
      );
    } catch (e) {
      print("removeUserRelation error: $e");
      rethrow;
    }
  }
}
