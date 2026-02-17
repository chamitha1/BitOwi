import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';
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
  String _verifiedOtp = "";
  bool _isEmailVerified = false;
  bool _isSendingOtp = false;

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
    if (!_isEmailVerified) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please verify your email first",
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
    try {
      await UserApi.bindGoogleSecret(
        googleCaptcha: googleCode,
        secret: _secretKey,
        smsCaptcha: _verifiedOtp,
      );

      AppLogger.d("AddAuthenticatorPage: bindGoogleSecret success");

      await Get.find<UserController>().loadUser();

      setState(() => _isLoading = false);
      _showSuccessDialog();
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

  Future<void> _verifyEmail() async {
    if (_isSendingOtp || _isEmailVerified) return;

    final userController = Get.find<UserController>();
    final email =
        userController.user.value?.loginName ??
        userController.user.value?.email ??
        "";

    if (email.isEmpty) {
      CustomSnackbar.showError(title: "Error", message: "User email not found");
      return;
    }

    setState(() => _isSendingOtp = true);

    try {
      final success = await _userApi.sendOtp(
        email: email,
        bizType: SmsBizType.openGoogle, // Use OPEN_GOOGLE
      );

      if (!mounted) return;

      if (!success) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send verification code",
        );
        return;
      }

      CustomSnackbar.showSuccess(
        title: "Success",
        message: "OTP sent to your email!",
      );

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: email,
          otpLength: 6,
          bizType: SmsBizType.openGoogle, // Use OPEN_GOOGLE
          onVerifyPin: (pin) async {
            _verifiedOtp = pin; // Store locally
            return await UserApi().verifyOtp(
              email: email,
              otp: pin,
              bizType: SmsBizType.openGoogle,
            );
          },
          onResend: () async {
            return await _userApi.sendOtp(
              email: email,
              bizType: SmsBizType.openGoogle,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            setState(() => _isEmailVerified = true);
            CustomSnackbar.showSuccess(
              title: "Verified",
              message: "Email verified successfully!",
            );
          },
        ),
      );
    } catch (e) {
      if (mounted) CustomSnackbar.showError(title: "Error", message: "$e");
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
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

                      // const SizedBox(height: 24),
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

                      TextFormField(
                        initialValue:
                            Get.find<UserController>().user.value?.loginName ??
                            Get.find<UserController>().user.value?.email ??
                            "",
                        readOnly: true,
                        style: const TextStyle(
                          color: Color(0XFF717F9A),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFECEFF5),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              top: 14.0,
                              bottom: 14.0,
                              right: 4.0,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/sign_up/sms.svg",
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF717F9A),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 6,
                              top: 6,
                              bottom: 6,
                            ),
                            child: _verifyButton(
                              text: _isEmailVerified
                                  ? "Verified"
                                  : (_isSendingOtp
                                        ? "Sending..."
                                        : "Get a Code"),
                              onPressed: _verifyEmail,
                              isEnabled: !_isSendingOtp && !_isEmailVerified,
                              isVerified: _isEmailVerified,
                            ),
                          ),
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
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFDAE0EE),
                            ),
                          ),
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
          borderRadius: BorderRadius.circular(8),
          border: isVerified
              ? Border.all(color: const Color(0xFFABEAC6), width: 1.0)
              : null,
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
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: Color(0xFF40A372),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
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
