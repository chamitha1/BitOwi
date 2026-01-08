import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
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
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    final newEmail = _newEmailController.text.trim();
    if (!GetUtils.isEmail(newEmail)) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter a valid email address",
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

    _openOtpSheet(newEmail);
  }

  Future<void> _openOtpSheet(String newEmail) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final success = await _userApi.sendOtp(
        email: newEmail,
        bizType: SmsBizType.modifyEmail,
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

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: newEmail,
          otpLength: 6,
          bizType: SmsBizType.modifyEmail,
          onVerifyPin: (pin) async {
            try {
              await _userApi.modifyEmail(newEmail: newEmail, otp: pin);
              return true;
            } catch (e) {
              print(e);
              return false;
            }
          },
          onResend: () async {
            return await _userApi.sendOtp(
              email: newEmail,
              bizType: SmsBizType.modifyEmail,
            );
          },
          onVerified: () {
            Navigator.pop(context); // Close OTP Sheet
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF151E2F)),
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

              // Current Email disabled
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
                enabled: false,
                style: const TextStyle(
                  color: Color(0xFF151E2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFECEFF5), // Disabled color
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/login/sms.svg',
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
                  // Borders
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
                  ),
                  enabledBorder: OutlineInputBorder(
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
              TextField(
                controller: _newEmailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Color(0xFF151E2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: "Enter New Email",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF717F9A),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/login/sms.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF717F9A), // Matched Signup color
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
                ),
              ),

              const Spacer(),

              // update email btn
              SizedBox(
                width: double.infinity,
                height: 56,
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
}
