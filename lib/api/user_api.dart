import 'package:BitDo/config/api_client.dart';
import 'package:BitDo/features/auth/presentation/pages/login_screen.dart';
import 'package:BitDo/features/auth/presentation/pages/signup_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:BitDo/constants/sms_constants.dart';

class UserApi {
  //Login API
  Future<LoginScreen> login({
    required String loginName,
    required String loginPwd,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/cuser/public/login',
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
        '/cuser/public/register_by_email',
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
      final response = await ApiClient.dio.post(
        '/sms_out/permission_none/email_code',
        data: {'email': email, 'bizType': bizType.value},
      );

      final data = response.data as Map<String, dynamic>;
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
}
