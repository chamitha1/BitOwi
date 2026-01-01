import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart'; // Added import
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart'; // Ensure correct import
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeTransactionPasswordPage extends StatefulWidget {
  const ChangeTransactionPasswordPage({super.key});

  @override
  State<ChangeTransactionPasswordPage> createState() =>
      _ChangeTransactionPasswordPageState();
}

class _ChangeTransactionPasswordPageState
    extends State<ChangeTransactionPasswordPage> {
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

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onUpdate() async {
    final pass = _passController.text.trim();
    final confirm = _confirmPassController.text.trim();

    if (pass.isEmpty || pass.length != 6 || int.tryParse(pass) == null) {
      _toast("Please enter a valid 6-digit number password");
      return;
    }
    if (confirm != pass) {
      _toast("Passwords do not match");
      return;
    }
    _openOtpSheet();
  }

  Future<void> _openOtpSheet() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Send OTP first
      final success = await _userApi.sendOtp(
        email: _email,
        bizType: SmsBizType.bindTradePwd,
      );

      if (!mounted) return;

      if (!success) {
        _toast("Failed to send OTP. Please try again.");
        setState(() => _isLoading = false);
        return;
      }

      setState(() => _isLoading = false);

      final pendingPassword = _passController.text.trim();
      _passController.clear();
      _confirmPassController.clear();

      // Show Sheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OtpBottomSheet(
          email: _email,
          otpLength: 6,
          bizType: SmsBizType.bindTradePwd,
          //  API verify here
          onVerifyPin: (pin) async {
            try {
              await _userApi.bindTradePwd(
                email: _email,
                smsCode: pin,
                tradePwd: pendingPassword,
              );
              return true;
            } catch (e) {
              print(e);
              return false;
            }
          },
          // resend api
          onResend: () async {
            return await _userApi.sendOtp(
              email: _email,
              bizType: SmsBizType.bindTradePwd,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            Get.back();
            Get.snackbar(
              "Success",
              "Transaction Password Updated Successfully!",
              backgroundColor: const Color(0xFFEAF9F0),
              colorText: const Color(0xFF40A372),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(20),
            );
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _toast("Error: $e");
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
          "Change Transaction Password",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Color(0XFF151E2F),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Email"),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDAE0EE)),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/sign_up/sms.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF717F9A),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _email,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF151E2F),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF9F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFABEAC6)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Color(0xFF40A372),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Verified",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF40A372),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _label("Transaction Password"),
              _passwordField(
                controller: _passController,
                placeholder: "Enter 6-Digit Password",
              ),
              const SizedBox(height: 24),

              _label("Confirm Transaction Password"),
              _passwordField(
                controller: _confirmPassController,
                placeholder: "Re-enter 6-Digit Password",
              ),
              const SizedBox(height: 40),

              SizedBox(
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
                          "Update Transaction Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
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
  }) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Color(0xFF717F9A),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
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
        suffixIcon: IconButton(
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
    );
  }
}
