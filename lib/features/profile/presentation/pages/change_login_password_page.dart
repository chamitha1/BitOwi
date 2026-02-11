import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeLoginPasswordPage extends StatefulWidget {
  const ChangeLoginPasswordPage({super.key});

  @override
  State<ChangeLoginPasswordPage> createState() =>
      _ChangeLoginPasswordPageState();
}

class _ChangeLoginPasswordPageState extends State<ChangeLoginPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _userApi = UserApi();

  bool _submitted = false;

  String _email = '';
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  String _verifiedOtp = "";
  bool _isEmailVerified = false;
  bool _isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final userController = Get.find<UserController>();
    // Ensure user data is loaded
    if (userController.user.value == null) {
      await userController.loadUser();
    }

    final user = userController.user.value;
    final email = user?.loginName ?? user?.email;

    if (mounted && email != null) {
      setState(() => _email = email);
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    FocusScope.of(context).unfocus();

    // Trigger validation
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final pass = _passController.text.trim();
    final confirm = _confirmPassController.text.trim();

    if (confirm != pass) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Passwords do not match",
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

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newPassword = _passController.text.trim();
      await UserApi.forgetLoginPwd(
        email: _email,
        smsCaptcha: _verifiedOtp,
        loginPwd: newPassword,
      );
      AppLogger.d("ChangeLoginPasswordPage: forgetLoginPwd success");

      setState(() => _isLoading = false);

      // Success Dialog
      Get.dialog(
        SuccessDialog(
          title: "Successfully Changed",
          description:
              "Your login password has changed successfully. Please use the new password for future logins.",
          buttonText: "Done",
          onButtonTap: () {
            Get.back(); // close dialog
            Get.back(); // navigate back from Change Page
          },
        ),
        barrierDismissible: false,
      );

      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Login Password Changed Successfully!",
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackbar.showError(
          title: "Error",
          message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    }
  }

  Future<void> _verifyEmail() async {
    if (_isSendingOtp || _isEmailVerified) return;
    setState(() => _isSendingOtp = true);

    try {
      final success = await _userApi.sendOtp(
        email: _email,
        bizType: SmsBizType.forgetPwd,
      );
      AppLogger.d("ChangeLoginPasswordPage: sendOtp success: $success");

      if (!mounted) return;

      if (!success) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to send OTP. Please try again.",
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
          email: _email,
          otpLength: 6,
          bizType: SmsBizType.forgetPwd,
          onVerifyPin: (pin) async {
            // Local verify only - save OTP
            _verifiedOtp = pin;
            return await UserApi().verifyOtp(
              email: _email,
              otp: pin,
              bizType: SmsBizType.forgetPwd,
            );
          },
          onResend: () async {
            return await _userApi.sendOtp(
              email: _email,
              bizType: SmsBizType.resetLoginPwd,
            );
          },
          onVerified: () {
            Navigator.pop(context); // Close OTP sheet
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter password';
    }
    if (value != _passController.text) {
      return 'Passwords do not match';
    }
    return null;
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
          "Change Login Password",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Email"),
                      TextFormField(
                        initialValue: _email,
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
                              isEnabled: _email.isNotEmpty && !_isSendingOtp,
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

                      _label("New Login Password"),
                      _passwordField(
                        controller: _passController,
                        placeholder: "Enter New Password",
                        validator: _validatePassword,
                        showSuffix: true,
                        enabled: _isEmailVerified,
                        isVisible: _isNewPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      _label("Confirm New Login Password"),
                      _passwordField(
                        controller: _confirmPassController,
                        placeholder: "Re-Enter New Password",
                        validator: _validateConfirmPassword,
                        showSuffix: true,
                        enabled: _isEmailVerified,
                        isVisible: _isConfirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isEmailVerified && !_isLoading)
                      ? _onUpdate
                      : null,
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
                          "Change Login Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
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
                      color: const Color(0xFF40A372),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2E3D5B),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String placeholder,
    String? Function(String?)? validator,
    bool showSuffix = true,
    bool enabled = true,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: !isVisible,
      decoration: _inputDecoration(
        hint: placeholder,
        iconPath: "assets/icons/sign_up/lock.svg",
        suffixIconPath: showSuffix && !isVisible
            ? "assets/icons/sign_up/eye.svg"
            : (showSuffix ? "assets/icons/sign_up/eye-slash.svg" : null),
        isPassword: showSuffix,
        enabled: enabled,
        isVisible: isVisible,
        onToggleVisibility: onToggleVisibility,
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
      onChanged: (_) {
        if (_submitted) setState(() {});
      },
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    bool enabled = true,
    String? suffixIconPath,
    Widget? suffixWidget,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
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
                onPressed: enabled ? onToggleVisibility : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    suffixIconPath,
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
