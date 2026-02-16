import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _newEmailController = TextEditingController();
  final UserApi _userApi = UserApi();
  String _currentEmail = "";
  bool _isLoading = false;

  String _oldEmailOtp = "";
  bool _isOldEmailVerified = false;
  bool _isSendingOtpOld = false;

  String _newEmailOtp = "";
  bool _isNewEmailVerified = false;
  bool _isSendingOtpNew = false;

  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  bool _isNewEmailPopulated = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _newEmailController.addListener(_onNewEmailChanged);
  }

  void _onNewEmailChanged() {
    final text = _newEmailController.text.trim();
    final populated = text.isNotEmpty;
    if (_isNewEmailPopulated != populated) {
      if (mounted) setState(() => _isNewEmailPopulated = populated);
    }

    // Reset verification if email changes
    if (_isNewEmailVerified) {
      if (mounted)
        setState(() {
          _isNewEmailVerified = false;
          _newEmailOtp = "";
        });
    }
  }

  Future<void> _loadUserEmail() async {
    final userController = Get.find<UserController>();
    if (userController.user.value == null) {
      await userController.loadUser();
    }
    final user = userController.user.value;
    final email = user?.loginName ?? user?.email;
    if (mounted && email != null) {
      setState(() => _currentEmail = email);
    }
  }

  @override
  void dispose() {
    _newEmailController.removeListener(_onNewEmailChanged);
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    // Final check
    if (!_isOldEmailVerified || !_isNewEmailVerified) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please verify both emails first.",
      );
      return;
    }

    final newEmail = _newEmailController.text.trim();

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final result = await _userApi.modifyEmail(
        newEmail: newEmail,
        smsCaptchaOld: _oldEmailOtp,
        smsCaptchaNew: _newEmailOtp,
      );
      AppLogger.d("ChangeEmailPage: modifyEmail result: $result");

      if (result['code'] == 200 || result['code'] == '200') {
        _showSuccessDialog();
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: result['errorMsg'] ?? "Update Failed",
        );
      }
    } catch (e) {
      AppLogger.d("ChangeEmailPage: modifyEmail error: $e");
      CustomSnackbar.showError(title: "Error", message: "$e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Verify Old Email
  Future<void> _verifyOldEmail() async {
    if (_isSendingOtpOld || _isOldEmailVerified) return;
    if (_currentEmail.isEmpty) return;

    setState(() => _isSendingOtpOld = true);

    try {
      final success = await _userApi.sendOtp(
        email: _currentEmail,
        bizType: SmsBizType.modifyEmail,
      );
      AppLogger.d("ChangeEmailPage: sendOtp (OLD) success: $success");

      if (!mounted) return;

      if (!success) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send OTP to current email.",
        );
        return;
      }

      CustomSnackbar.showSuccess(
        title: "Success",
        message: "OTP sent to your current email!",
      );

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: _currentEmail,
          otpLength: 6,
          bizType: SmsBizType.modifyEmail,
          onVerifyPin: (pin) async {
            // Local verify only - save OTP
            _oldEmailOtp = pin;
            return await UserApi().verifyOtp(
              email: _currentEmail,
              otp: pin,
              bizType: SmsBizType.modifyEmail,
            );
          },
          onResend: () async {
            return await _userApi.sendOtp(
              email: _currentEmail,
              bizType: SmsBizType.modifyEmail,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            setState(() => _isOldEmailVerified = true);
            CustomSnackbar.showSuccess(
              title: "Verified",
              message: "Current email verified!",
            );
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          title: "Error",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingOtpOld = false);
    }
  }

  // Verify New Email
  Future<void> _verifyNewEmail() async {
    if (_isSendingOtpNew || _isNewEmailVerified) return;
    final newEmail = _newEmailController.text.trim();

    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    if (!GetUtils.isEmail(newEmail)) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Invalid email address",
      );
      return;
    }

    if (newEmail == _currentEmail) {
      CustomSnackbar.showError(
        title: "Error",
        message: "New email cannot be the same as current email",
      );
      return;
    }

    setState(() => _isSendingOtpNew = true);

    try {
      final success = await _userApi.sendOtp(
        email: newEmail,
        bizType: SmsBizType.modifyEmail,
      );
      AppLogger.d("ChangeEmailPage: sendOtp (NEW) success: $success");

      if (!mounted) return;

      if (!success) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send OTP to new email.",
        );
        return;
      }

      CustomSnackbar.showSuccess(
        title: "Success",
        message: "OTP sent to new email!",
      );

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: newEmail,
          otpLength: 6,
          bizType: SmsBizType.modifyEmail,
          onVerifyPin: (pin) async {
            // Local verify only - save OTP
            _newEmailOtp = pin;
            return await UserApi().verifyNewEmailOtp(
              newEmail: newEmail,
              otp: pin,
            );
            ;
          },
          onResend: () async {
            return await _userApi.sendOtp(
              email: newEmail,
              bizType: SmsBizType.modifyEmail,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            setState(() => _isNewEmailVerified = true);
            CustomSnackbar.showSuccess(
              title: "Verified",
              message: "New email verified!",
            );
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          title: "Error",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingOtpNew = false);
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      SuccessDialog(
        title: "Email Updated Successfully",
        description:
            "Your email address has been changed. All future communications will be sent to your new email.",
        buttonText: "OK",
        onButtonTap: () {
          Get.back(); // Close Dialog
          Get.back(); // Close Change Email Page
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
          "Change Email",
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update the email address linked to your account. \nWe’ll verify it before making the change.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717F9A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Email
                    const Text(
                      "Current Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2E3D5B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _currentEmail,
                      readOnly: true,
                      style: const TextStyle(
                        color: Color(0xFF717F9A),
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
                            'assets/icons/login/sms.svg',
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
                            text: _isOldEmailVerified
                                ? "Verified"
                                : (_isSendingOtpOld
                                      ? "Sending..."
                                      : "Get a Code"),

                            onPressed: _verifyOldEmail,
                            isEnabled:
                                _currentEmail.isNotEmpty && !_isSendingOtpOld,
                            isVerified: _isOldEmailVerified,
                          ),
                        ),
                        // Borders
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
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // New Email
                    const Text(
                      "New Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2E3D5B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color(0xFF151E2F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                      validator: (value) {
                        final email = (value ?? "").trim();
                        if (email.isEmpty) return "Please enter email";
                        if (!GetUtils.isEmail(email))
                          return "Invalid email address";
                        if (email == _currentEmail)
                          return "New email cannot be the same as current email";
                        return null;
                      },
                      onChanged: (_) {
                        if (_submitted) setState(() {});
                      },
                      decoration: _inputDecoration(
                        hint: "Enter New Email",
                        iconPath: "assets/icons/login/sms.svg",
                        enabled: true,
                        suffixWidget: Padding(
                          padding: const EdgeInsets.only(
                            right: 6,
                            top: 6,
                            bottom: 6,
                          ),
                          child: _verifyButton(
                            text: _isNewEmailVerified
                                ? "Verified"
                                : (_isSendingOtpNew
                                      ? "Sending..."
                                      : "Get a Code"),
                            onPressed: _verifyNewEmail,
                            isEnabled:
                                _isNewEmailPopulated && !_isSendingOtpNew,
                            isVerified: _isNewEmailVerified,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // update email btn
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      (_isOldEmailVerified &&
                          _isNewEmailVerified &&
                          !_isLoading)
                      ? _onUpdate
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    disabledBackgroundColor: const Color(0xFFB9C6E2),
                    disabledForegroundColor: Colors.white,
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
                          "Update Email Address",
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

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    bool enabled = true,
    String? suffixIconPath,
    Widget? suffixWidget,
    bool isPassword = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFF717F9A),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFFE74C3C),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.0),
      ),

      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 14.0,
          bottom: 14.0,
          right: 6.0,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            Color(0XFF717F9A),
            BlendMode.srcIn,
          ),
        ),
      ),

      suffixIcon: isPassword && suffixIconPath != null
          ? Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: enabled ? null : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    suffixIconPath ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff2E3D5B),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            )
          : suffixWidget,

      filled: true,
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.disabled))
          return const Color(0xFFECEFF5);
        return Colors.white;
      }),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 112, 152, 221),
          width: 1.0,
        ),
      ),
    );
  }
}
