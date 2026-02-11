import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddAuthenticatorPage extends StatefulWidget {
  const AddAuthenticatorPage({super.key});

  @override
  State<AddAuthenticatorPage> createState() => _AddAuthenticatorPageState();
}

class _AddAuthenticatorPageState extends State<AddAuthenticatorPage> {
  final TextEditingController _codeController = TextEditingController();
  final UserApi _userApi = UserApi();

  String _secretKey = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSecretKey();
  }

  Future<void> _fetchSecretKey() async {
    try {
      final secret = await UserApi.getGoogleSecret();
      AppLogger.d("AddAuthenticatorPage: getGoogleSecret result: $secret");
      if (mounted) {
        setState(() {
          _secretKey = secret;
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(title: "Error", message: "$e");
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onEnable() async {
    final googleCode = _codeController.text.trim();
    if (googleCode.isEmpty || googleCode.length != 6) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter a valid 6-digit authenticator code",
      );
      return;
    }

    if (_secretKey.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Secret key not loaded",
      );
      return;
    }

    _openOtpSheet(googleCode);
  }

  Future<void> _openOtpSheet(String googleCode) async {
    final userController = Get.find<UserController>();
    final email =
        userController.user.value?.loginName ??
        userController.user.value?.email ??
        "";

    if (email.isEmpty) {
      CustomSnackbar.showError(title: "Error", message: "User email not found");
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Send OTP
      final success = await _userApi.sendOtp(
        email: email,
        bizType: SmsBizType.openGoogle,
      );
      AppLogger.d("AddAuthenticatorPage: sendOtp success: $success");

      if (!mounted) return;

      if (!success) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send OTP. Please try again.",
        );
        setState(() => _isLoading = false);
        return;
      }

      setState(() => _isLoading = false);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: email,
          otpLength: 6,
          bizType: SmsBizType.openGoogle,
          onVerifyPin: (pin) async {
            try {
              await UserApi.bindGoogleSecret(
                googleCaptcha: googleCode,
                secret: _secretKey,
                smsCaptcha: pin,
              );
              AppLogger.d("AddAuthenticatorPage: bindGoogleSecret success");
              return {'code': 200, 'msg': 'Success'};
            } catch (e) {
              AppLogger.d("AddAuthenticatorPage: bindGoogleSecret error: $e");
              CustomSnackbar.showError(title: "Error", message: "$e");
              return {'code': 500, 'msg': e.toString()};
            }
          },
          onResend: () async {
            final success = await _userApi.sendOtp(
              email: email,
              bizType: SmsBizType.openGoogle,
            );
            AppLogger.d(
              "AddAuthenticatorPage: Resend sendOtp success: $success",
            );
            return success;
          },
          onVerified: () async {
            Navigator.pop(context); // Close OTP Sheet
            await Get.find<UserController>().loadUser();
            _showSuccessDialog();
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackbar.showError(title: "Error", message: "$e");
      }
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      SuccessDialog(
        title: "Successfully Enabled",
        description:
            "Authenticator app enabled successfully. You’ll be asked for a verification code when signing in.",
        buttonText: "OK",
        onButtonTap: () {
          Get.back(); // Close Dialog
          Get.back(); // Close Page
        },
      ),
      barrierDismissible: false,
    );
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
          "Add Authenticator",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Color(0XFF151E2F),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
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
                      const Text(
                        "Set up two-factor authentication to add an extra layer of security to your account.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF717F9A),
                        ),
                      ),
                      const SizedBox(height: 32),

                      //Secret Key
                      const Text(
                        "Secret Key",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E3D5B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECEFF5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDAE0EE)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _secretKey.isNotEmpty
                                    ? _secretKey
                                    : "Loading...",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF717F9A),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_secretKey.isEmpty) return;
                                Clipboard.setData(
                                  ClipboardData(text: _secretKey),
                                );
                                Get.snackbar(
                                  "Copied",
                                  "Secret Key copied to clipboard",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black87,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/deposit/copy.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF1D5DE5),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Copy",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF1D5DE5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Copy this key and add it to your authenticator app (Google Authenticator, Authy, etc.).",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF717F9A),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Input Code
                      const Text(
                        "Authenticator App Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E3D5B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter 6-digit authenticator code",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF717F9A),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/icons/profile_page/account_security/hashtag.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF717F9A),
                                BlendMode.srcIn,
                              ),
                            ),
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

                      //Warning Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFE2C1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/profile_page/account_security/info-circle-orange.svg',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Setup Authenticator App",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0XFFC9710D),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Make sure your authenticator app is set up before enabling.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0XFFC9710D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // enable auth btn
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onEnable,
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
                                  "Enable Authentication",
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
}
