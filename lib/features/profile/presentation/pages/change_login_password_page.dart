import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
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

  String _email = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

    _openOtpSheet();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    // You might want to add more password rules here if needed
    // e.g. length check similar to login page
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

  Future<void> _openOtpSheet() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Send OTP first
      final success = await _userApi.sendOtp(
        email: _email,
        bizType: SmsBizType.forgetPwd,
      );

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

      final newPassword = _passController.text.trim();
      
      // Clear fields before showing sheet as per requirement
      // _passController.clear();
      // _confirmPassController.clear();
      // WARNING: If we clear here, if user cancels OTP sheet, they have to re-type.
      // Requirement says "clear textfields--> success dialog". So clearing AFTER success seems more appropriate or right before success dialog.
      // However, "clear textfields" is listed in the flow arrow chain: 
      // API called -> clear textfields -> success dialog
      // So I will clear them upon successful verification.

      // Show Sheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: _email,
          otpLength: 6,
          // Using forgetPwd biztype
          bizType: SmsBizType.forgetPwd,
          
          // API verification
          onVerifyPin: (pin) async {
            try {
              // Call forgetLoginPwd
              await UserApi.forgetLoginPwd(
                email: _email,
                smsCaptcha: pin,
                loginPwd: newPassword,
              );
              return true;
            } catch (e) {
              print(e);
              // Error snackbar is often handled by caller or we can show it here if we return false
              // OtpBottomSheet usually shows error if this returns false? 
              // Looking at OtpBottomSheet implementation (not provided in context but inferred), 
              // if onVerifyPin throws or returns false, it might handle UI.
              // Requirement: "If the otp verification fails --> show error snack bar with errorMsg from response."
              // The API method rethrows, so we catch it here.
              CustomSnackbar.showError(title: "Error", message: e.toString().replaceAll("Exception: ", ""));
              return false;
            }
          },
          // resend api
          onResend: () async {
            return await _userApi.sendOtp(
              email: _email,
              bizType: SmsBizType.forgetPwd,
            );
          },
          onVerified: () {
            // Close OTP sheet
            Navigator.pop(context); // or Get.back();

            // Clear textfields
            _passController.clear();
            _confirmPassController.clear();

            // Success Dialog
            Get.dialog(
              SuccessDialog(
                title: "Successfully Changed",
                description: "Your login password has changed successfully. Please use the new password for future logins.",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Email"),
                      TextFormField(
                        initialValue: _email,
                        enabled: false,
                        style: const TextStyle(
                          color: Color(0xFF151E2F),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFECEFF5),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              "assets/icons/sign_up/sms.svg",
                              width: 20,
                              height: 20,
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
                              text: "Verified",
                              onPressed: () {},
                              isEnabled: false,
                              isVerified: true,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _label("New Login Password"),
                      _passwordField(
                        controller: _passController,
                        placeholder: "Enter New Password",
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),

                      _label("Confirm New Login Password"),
                      _passwordField(
                        controller: _confirmPassController,
                        placeholder: "Re-Enter New Password",
                        validator: _validateConfirmPassword,
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
                  onPressed: _isLoading ? null : _onUpdate,
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
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isVerified
              ? const Color(0xffEAF9F0)
              : (isEnabled ? null : const Color(0XFFB9C6E2)),
          gradient: (isEnabled && !isVerified)
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
                )
              : null,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: (isEnabled && !isVerified) ? onPressed : null,
          child: isVerified
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/sign_up/check_circle.png",
                      width: 14,
                      height: 14,
                      color: const Color(0xFF40A372),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      // Removed keyboardType: TextInputType.number to allow alphanumeric passwords as per example "1qaz!QAZ"
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Color(0xFF717F9A),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D5DE5)),
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
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            "assets/icons/sign_up/lock.svg",
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF717F9A),
              BlendMode.srcIn,
            ),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6, top: 6, bottom: 6),
          child: IconButton(
            icon: SvgPicture.asset(
              !_isPasswordVisible
                  ? "assets/icons/sign_up/eye.svg"
                  : "assets/icons/sign_up/eye-slash.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF2E3D5B),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
      validator: validator,
      onChanged: (_) {
         // Optionally clear validation errors on type
         // _formKey.currentState?.validate();
      },
    );
  }
}
