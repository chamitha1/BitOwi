import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/gradient_button.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final userApi = UserApi();

  // Only use Form for UI error rendering, but we will validate email separately on Verify
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _emailController; // Autocomplete manages it
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  FocusNode? _autocompleteFocusNode;
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;

  bool _isSendingOtp = false;
  bool _isSubmitting = false;
  bool _submitted = false;

  String _verifiedSmsCode = "";
  String? _verifiedEmail; // ✅ store verified email, so we only reset when it changes

  static const List<String> _emailDomains = <String>[
    'gmail.com',
    'hotmail.com',
    'outlook.com',
    'yahoo.com',
    'icloud.com',
    'live.com',
  ];

  final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ----------------------------
  // UI helpers
  // ----------------------------

  void _showTopError(String message) {
    // works on web + mobile (requires GetMaterialApp)
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.white,
      colorText: const Color(0xFF151E2F),
      borderColor: const Color(0xFFE74C3C),
      borderWidth: 1,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Color(0xFFE74C3C)),
    );
  }

  String _extractBackendError(dynamic e) {
    try {
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          final msg = data["errorMsg"] ?? data["message"] ?? data["msg"];
          if (msg != null) return msg.toString();
        }
        return e.message ?? "Request failed";
      }
      // older dio versions
      if (e is DioError) {
        final data = e.response?.data;
        if (data is Map) {
          final msg = data["errorMsg"] ?? data["message"] ?? data["msg"];
          if (msg != null) return msg.toString();
        }
        return e.message ?? "Request failed";
      }
    } catch (_) {}

    return e.toString().replaceFirst("Exception: ", "");
  }

  // ✅ validate email only (used on Verify)
  String? _validateEmail(String? v) {
    final email = (v ?? "").trim();
    if (email.isEmpty) return "Please enter your email";
    if (!_emailRegex.hasMatch(email)) return "Invalid email format";
    return null;
  }

  // ✅ IMPORTANT: do not show password errors until email is verified
  String? _validatePassword(String? v) {
    if (!_isEmailVerified) return null;
    final pass = (v ?? "").trim();
    if (pass.isEmpty) return "Password cannot be empty";
    if (pass.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateConfirm(String? v) {
    if (!_isEmailVerified) return null;
    final confirm = (v ?? "").trim();
    final pass = _passController.text.trim();
    if (confirm.isEmpty) return "Please confirm password";
    if (confirm != pass) return "Passwords do not match";
    return null;
  }

  Future<void> _sendOtpAndVerify() async {
    if (_isSendingOtp) return;

    FocusScope.of(context).unfocus();
    _autocompleteFocusNode?.unfocus();

    // turn on validation UI
    setState(() => _submitted = true);

    final email = _emailController?.text.trim() ?? "";
    final emailErr = _validateEmail(email);
    if (emailErr != null) {
      // force redraw so TextFormField shows its error
      _formKey.currentState?.validate();
      _showTopError(emailErr);
      return;
    }

    if (_isEmailVerified) return;

    setState(() => _isSendingOtp = true);

    try {
      final bool sent = await userApi.sendOtp(
        email: email,
        bizType: SmsBizType.forgetPwd,
      );

      if (!mounted) return;

      if (!sent) {
        _showTopError("Failed to send OTP. Please try again.");
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
        barrierColor: const Color(0xFFECEFF5).withOpacity(0.7),
        builder: (context) => OtpBottomSheet(
          email: email,
          otpLength: 6,
          bizType: SmsBizType.forgetPwd,
          onVerifyPin: (pin) async {
            _verifiedSmsCode = pin;
            return true; // if you have real verify endpoint, call it here
          },
          onResend: () async {
            return await userApi.sendOtp(
              email: email,
              bizType: SmsBizType.forgetPwd,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            setState(() {
              _isEmailVerified = true;
              _verifiedEmail = email; // ✅ keep what was verified
            });
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Email Verified Successfully!",
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showTopError(_extractBackendError(e));
    } finally {
      if (mounted) setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _submitReset() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);

    if (!_isEmailVerified) {
      _showTopError("Please verify your email first.");
      return;
    }

    // now validate passwords only
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (_verifiedSmsCode.trim().isEmpty) {
      _showTopError("OTP is missing. Please verify again.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await UserApi.forgetLoginPwd(
        email: (_emailController?.text ?? "").trim(),
        smsCaptcha: _verifiedSmsCode,
        loginPwd: _passController.text.trim(),
      );

      if (!mounted) return;
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Password Reset Successful!",
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showTopError(_extractBackendError(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ----------------------------
  // Build
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool wide = constraints.maxWidth >= 700;
            final double maxW = wide ? 520 : 9999;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: wide ? 0 : 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: maxW,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: wide ? 24.0 : 0),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 56,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SvgPicture.asset(
                                        'assets/icons/merchant_details/arrow_left.svg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: Color(0xff151E2F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "No worries—tell us your email and we'll help you reset your password safely.",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: Color(0xff454F63),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 36),

                            _textLabel("Email"),
                            _emailAutocompleteField(
                              hint: "Enter your email",
                              iconPath: "assets/icons/sign_up/sms.svg",
                              enabled: !_isEmailVerified,
                              suffixWidget: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: _verifyButton(
                                  text: _isEmailVerified
                                      ? "Verified"
                                      : (_isSendingOtp ? "Sending..." : "Verify"),
                                  isEnabled: _isEmailPopulated && !_isSendingOtp,
                                  isVerified: _isEmailVerified,
                                  onPressed: _sendOtpAndVerify,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            _textLabel("New Password"),
                            TextFormField(
                              controller: _passController,
                              focusNode: _passFocus,
                              enabled: _isEmailVerified,
                              obscureText: !_isPasswordVisible,
                              validator: _validatePassword,
                              onChanged: (_) {
                                if (_submitted) setState(() {});
                              },
                              decoration: _inputDecoration(
                                hint: "Enter New Password",
                                iconPath: "assets/icons/sign_up/lock.svg",
                                suffixIconPath: !_isPasswordVisible
                                    ? "assets/icons/sign_up/eye.svg"
                                    : "assets/icons/sign_up/eye-slash.svg",
                                isPassword: true,
                                enabled: _isEmailVerified,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _textLabel("Confirm Password"),
                            TextFormField(
                              controller: _confirmPassController,
                              focusNode: _confirmFocus,
                              enabled: _isEmailVerified,
                              obscureText: !_isPasswordVisible,
                              validator: _validateConfirm,
                              decoration: _inputDecoration(
                                hint: "Re-Enter New Password",
                                iconPath: "assets/icons/sign_up/lock.svg",
                                suffixIconPath: !_isPasswordVisible
                                    ? "assets/icons/sign_up/eye.svg"
                                    : "assets/icons/sign_up/eye-slash.svg",
                                isPassword: true,
                                enabled: _isEmailVerified,
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 40),

                            GradientButton(
                              text: _isSubmitting ? "Updating..." : "Update",
                              onPressed: (!_isSubmitting)
                                  ? _submitReset
                                  : () {},
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ----------------------------
  // Widgets
  // ----------------------------

  Widget _textLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff2E3D5B),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    Widget? suffixWidget,
    bool isPassword = false,
    bool enabled = true,
    String? suffixIconPath,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xff717F9A),
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFE74C3C),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
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
          iconPath,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xff717F9A),
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: isPassword && suffixIconPath != null
          ? Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: enabled
                    ? () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        )
                    : null,
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
        if (states.contains(MaterialState.disabled)) {
          return const Color(0xFFECEFF5);
        }
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
    required Widget suffixWidget,
    bool enabled = true,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final input = value.text.trim();
        if (input.isEmpty) return const Iterable<String>.empty();

        if (_emailDomains.any(
          (d) => input.toLowerCase() == '${_localPart(input).toLowerCase()}@$d',
        )) {
          return const Iterable<String>.empty();
        }

        final atIndex = input.indexOf('@');
        if (atIndex < 0) {
          return _emailDomains.map((d) => '$input@$d');
        }

        final local = input.substring(0, atIndex);
        final typedDomain = input.substring(atIndex + 1).toLowerCase();
        if (local.isEmpty) return const Iterable<String>.empty();

        final matches =
            _emailDomains.where((d) => d.toLowerCase().startsWith(typedDomain));
        return matches.map((d) => '$local@$d');
      },
      onSelected: (String selection) {
        _emailController?.text = selection;
        _emailController?.selection = TextSelection.fromPosition(
          TextPosition(offset: selection.length),
        );
        setState(() {
          _isEmailPopulated = selection.trim().isNotEmpty;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_emailController != controller) {
          _emailController = controller;
          _autocompleteFocusNode = focusNode;

          _emailController!.addListener(() {
            final t = _emailController!.text.trim();
            final populated = t.isNotEmpty;

            // ✅ reset ONLY if email actually changed from verified email
            if (_isEmailVerified && _verifiedEmail != null && t != _verifiedEmail) {
              setState(() {
                _isEmailVerified = false;
                _verifiedSmsCode = "";
                _verifiedEmail = null;
                _passController.clear();
                _confirmPassController.clear();
              });
            }

            if (_isEmailPopulated != populated) {
              setState(() => _isEmailPopulated = populated);
            }
          });
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          decoration: _inputDecoration(
            hint: hint,
            iconPath: iconPath,
            suffixWidget: suffixWidget,
            enabled: enabled,
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: const Color(0XFFF6F9FF),
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 340),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(opt),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        opt,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0XFF151E2F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _localPart(String emailLike) {
    final idx = emailLike.indexOf('@');
    if (idx < 0) return emailLike;
    return emailLike.substring(0, idx);
  }
}