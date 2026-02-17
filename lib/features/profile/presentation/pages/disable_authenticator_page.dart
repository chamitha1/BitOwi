import 'dart:async';

import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DisableAuthenticatorPage extends StatefulWidget {
  const DisableAuthenticatorPage({super.key});

  @override
  State<DisableAuthenticatorPage> createState() =>
      _DisableAuthenticatorPageState();
}

class _DisableAuthenticatorPageState extends State<DisableAuthenticatorPage> {
  final TextEditingController _googleCodeController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  final UserApi _userApi = UserApi();

  bool _isLoading = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _googleCodeController.dispose();
    _smsCodeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _countdown = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _sendOtp() async {
    final userController = Get.find<UserController>();
    final email =
        userController.user.value?.loginName ??
        userController.user.value?.email ??
        "";

    if (email.isEmpty) {
      CustomSnackbar.showError(title: "Error", message: "User email not found");
      return;
    }

    try {
      final success = await _userApi.sendOtp(
        email: email,
        bizType: SmsBizType.closeGoogle,
      );

      if (success) {
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "Verification code sent",
        );
        _startTimer();
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send verification code",
        );
      }
    } on DioException catch (e) {
      AppLogger.d("API error: $e");
      final data = e.response?.data;
      final msg = (data is Map) ? (data['errorMsg'] ?? e.message) : e.message;
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackbar.showError(
          title: "Error",
          message: msg ?? 'Unknown error',
        );
      }
    } catch (e) {
      AppLogger.d("Unexpected error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
        if (mounted) {
          setState(() => _isLoading = false);
          CustomSnackbar.showError(title: "Error", message: errorMsg);
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          CustomSnackbar.showError(
            title: "Error",
            message: 'Unexpected error occurred',
          );
        }
      }
    }
  }

  Future<void> _onDisable() async {
    final googleCode = _googleCodeController.text.trim();
    final smsCode = _smsCodeController.text.trim();

    if (googleCode.isEmpty || googleCode.length != 6) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter a valid 6-digit authenticator code",
      );
      return;
    }

    if (smsCode.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter verification code",
      );
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await UserApi.closeGoogleSecret(
        googleCaptcha: googleCode,
        smsCaptcha: smsCode,
      );

      // Refresh
      final userController = Get.find<UserController>();
      await userController.loadUser();

      setState(() => _isLoading = false);
      _googleCodeController.clear();
      _smsCodeController.clear();

      Get.dialog(
        SuccessDialog(
          title: "Successfully Disabled",
          description: "Google Authenticator has been disabled successfully.",
          buttonText: "OK",
          onButtonTap: () {
            Get.back(); // Close Dialog
            Get.back(); // Close Page
          },
        ),
        barrierDismissible: false,
      );
    } on DioException catch (e) {
      AppLogger.d("API error: $e");
      final data = e.response?.data;
      final msg = (data is Map) ? (data['errorMsg'] ?? e.message) : e.message;
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackbar.showError(
          title: "Error",
          message: msg ?? 'Unknown error',
        );
      }
    } catch (e) {
      AppLogger.d("Unexpected error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
        if (mounted) {
          setState(() => _isLoading = false);
          CustomSnackbar.showError(title: "Error", message: errorMsg);
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          CustomSnackbar.showError(
            title: "Error",
            message: 'Unexpected error occurred',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Disable Authenticator",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Color(0XFF151E2F),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Authenticator Code Field
                      const Text(
                        "Authenticator Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E3D5B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _googleCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Authenticator code",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF717F9A),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF1D5DE5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Verification Code Field
                      const Text(
                        "Email Verification Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E3D5B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _smsCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter code",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF717F9A),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF1D5DE5),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 6,
                              top: 6,
                              bottom: 6,
                            ),
                            child: _verifyButton(
                              text: _countdown > 0
                                  ? "${_countdown}s"
                                  : "Get a code",
                              onPressed: _sendOtp,
                              isEnabled: _countdown == 0,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Disable Button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onDisable,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D5DE5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Disable",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _verifyButton({
    required String text,
    required VoidCallback onPressed,
    required bool isEnabled,
    bool isVerified = false,
  }) {
    return SizedBox(
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isVerified
              ? const Color(0xffEAF9F0)
              : (isEnabled ? const Color(0xFF1D5DE5) : const Color(0XFFB9C6E2)),
          border: isVerified
              ? Border.all(color: const Color(0xFFABEAC6), width: 1.0)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: isVerified ? 10 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: (isEnabled && !isVerified) ? onPressed : null,
          child: isVerified
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/forgot_password/check_circle.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF40A372),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Color(0xFF40A372),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
