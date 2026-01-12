import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/gradient_button.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/rich_text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final userApi = UserApi();

  TextEditingController? _emailController; // managed by Autocomplete
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteController = TextEditingController();

  FocusNode? _autocompleteFocusNode;

  bool _agreedToTerms = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;

  bool _sendingOtp = false;
  bool _signingUp = false;
  bool _submitted = false;

  String? _verifiedOtp;
  String _lastEmail = "";

  late final TapGestureRecognizer _termsRec;
  late final TapGestureRecognizer _privacyRec;

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
  void initState() {
    super.initState();

    _termsRec = TapGestureRecognizer()
      ..onTap = () {
        Get.to(
          () => const RichTextConfig(
            title: "Terms & Condition",
            configKey: "registered_agreement_textarea",
            configType: "system",
          ),
        );
      };

    _privacyRec = TapGestureRecognizer()
      ..onTap = () {
        Get.to(
          () => const RichTextConfig(
            title: "Privacy Policy",
            configKey: "privacy_agreement_textarea",
            configType: "system",
          ),
        );
      };
  }

  @override
  void dispose() {
    _termsRec.dispose();
    _privacyRec.dispose();

    _passController.dispose();
    _confirmPassController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  // ----------------------------
  // Helpers
  // ----------------------------

  void _showTopError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: const Color(0xFFFDF4F5),
      colorText: const Color(0xFFCF4436),
      borderColor: const Color(0xFFF5B7B1),
      borderWidth: 1,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Color(0xFFCF4436)),
    );
  }

  String _extractBackendMsg(dynamic e) {
    final s = e.toString();
    return s.replaceFirst("Exception: ", "");
  }

  String? _validateEmail(String? v) {
    final email = (v ?? "").trim();
    if (email.isEmpty) return "Please enter your email";
    if (!_emailRegex.hasMatch(email)) return "Invalid email format";
    return null;
  }

  String? _validatePassword(String? v) {
    if (!_isEmailVerified) return null; // don't show error before verification
    final pass = (v ?? "").trim();
    if (pass.isEmpty) return "Please enter password";
    if (pass.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateConfirm(String? v) {
    if (!_isEmailVerified) return null; // don't show error before verification
    final confirm = (v ?? "").trim();
    final pass = _passController.text.trim();
    if (confirm.isEmpty) return "Please confirm password";
    if (confirm != pass) return "Passwords do not match";
    return null;
  }

  // ----------------------------
  // OTP + Signup
  // ----------------------------

  Future<void> _openOtpSheet() async {
    if (_sendingOtp) return;

    FocusScope.of(context).unfocus();
    _autocompleteFocusNode?.unfocus();

    setState(() => _submitted = true);

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController?.text.trim() ?? "";
    if (email.isEmpty) return;

    setState(() => _sendingOtp = true);

    try {
      final success = await userApi.sendOtp(
        email: email,
        bizType: SmsBizType.register,
      );

      if (!mounted) return;

      if (!success) {
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
          bizType: SmsBizType.register,
          onVerifyPin: (pin) async {
            // ✅ If you have a real verify endpoint, call it here and return true/false.
            // final ok = await userApi.verifyOtp(email: email, bizType: SmsBizType.register, smsCode: pin);
            // return ok;

            _verifiedOtp = pin; // store OTP entered
            return true;
          },
          onResend: () async {
            return await userApi.sendOtp(
              email: email,
              bizType: SmsBizType.register,
            );
          },
          onVerified: () {
            Navigator.pop(context);
            setState(() => _isEmailVerified = true);
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Email Verified Successfully!",
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showTopError(_extractBackendMsg(e));
    } finally {
      if (mounted) setState(() => _sendingOtp = false);
    }
  }

  Future<void> _onSignup() async {
    if (_signingUp) return;

    FocusScope.of(context).unfocus();

    setState(() => _submitted = true);

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (!_isEmailVerified) {
      _showTopError("Please verify your email first.");
      return;
    }

    if ((_verifiedOtp ?? "").trim().isEmpty) {
      _showTopError("OTP missing. Please verify again.");
      return;
    }

    if (!_agreedToTerms) {
      _showTopError("Please read and accept Terms & Privacy");
      return;
    }

    // if (!passwordsValid || !termsValid) return;

    setState(() => _signingUp = true);

    try {
      final resData = await userApi.signup(
        email: _emailController!.text.trim(),
        smsCode: _verifiedOtp ?? "",
        loginPwd: _passController.text.trim(),
        inviteCode: _inviteController.text.trim().isEmpty
            ? null
            : _inviteController.text.trim(),
      );

      if (!mounted) return;

      final code = resData['code'];
      if (code == 200 || code == '200') {
        final tokenData = (resData['data'] as Map<String, dynamic>? ?? {});
        final token = tokenData['token'] as String? ?? '';

        await StorageService.saveToken(token);
        await StorageService.saveUserName(_emailController!.text.trim());

        Get.offAllNamed(Routes.home);
      } else {
        final msg =
            (resData['errorMsg'] ?? resData['message'] ?? "Signup failed")
                .toString();
        _showTopError(msg);
      }
    } catch (e) {
      if (!mounted) return;
      _showTopError(_extractBackendMsg(e));
    } finally {
      if (mounted) setState(() => _signingUp = false);
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
            final wide = constraints.maxWidth >= 700;
            final maxW = wide ? 520.0 : double.infinity;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: wide ? 0 : 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: wide ? 24.0 : 0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 56),
                          const Text(
                            "Let's Get You Started",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              color: Color(0XFF151E2F),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Set up your profile with strong protection for safe crypto trading and storage.",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff717F9A),
                            ),
                          ),
                          const SizedBox(height: 28),

                          _textLabel("Email"),
                          _emailAutocompleteField(
                            hint: "Enter your email",
                            iconPath: "assets/icons/sign_up/sms.svg",
                            suffixWidget: Padding(
                              // ✅ SAME padding for Verify + Verified
                              padding: const EdgeInsets.only(
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              child: _verifyButton(
                                text: _isEmailVerified
                                    ? "Verified"
                                    : (_sendingOtp ? "Sending..." : "Verify"),
                                isEnabled: _isEmailPopulated && !_sendingOtp,
                                isVerified: _isEmailVerified,
                                onPressed: _openOtpSheet,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          _textLabel("Password"),
                          TextFormField(
                            controller: _passController,
                            enabled: _isEmailVerified,
                            obscureText: !_isNewPasswordVisible,
                            validator: _validatePassword,
                            onChanged: (_) {
                              if (_submitted) setState(() {});
                            },
                            decoration: _inputDecoration(
                              hint: "Enter Password",
                              iconPath: "assets/icons/sign_up/lock.svg",
                              suffixIconPath: !_isNewPasswordVisible
                                  ? "assets/icons/sign_up/eye.svg"
                                  : "assets/icons/sign_up/eye-slash.svg",
                              isPassword: true,
                              enabled: _isEmailVerified,
                              onToggleVisibility: () {
                                setState(() {
                                  _isNewPasswordVisible = !_isNewPasswordVisible;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 30),

                          _textLabel("Confirm Password"),
                          TextFormField(
                            controller: _confirmPassController,
                            enabled: _isEmailVerified,
                            obscureText: !_isConfirmPasswordVisible,
                            validator: _validateConfirm,
                            decoration: _inputDecoration(
                              hint: "Re-Enter Password",
                              iconPath: "assets/icons/sign_up/lock.svg",
                              suffixIconPath: !_isConfirmPasswordVisible
                                  ? "assets/icons/sign_up/eye.svg"
                                  : "assets/icons/sign_up/eye-slash.svg",
                              isPassword: true,
                              enabled: _isEmailVerified,
                              onToggleVisibility: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 30),

                          _textLabel("Invitation Code (optional)"),
                          TextField(
                            controller: _inviteController,
                            enabled: _isEmailVerified,
                            decoration: _inputDecoration(
                              hint: "Please Enter Your Code",
                              iconPath: "assets/icons/sign_up/hashtag.svg",
                              enabled: _isEmailVerified,
                            ),
                          ),
                          const SizedBox(height: 22),

                          // ✅ ONE LINE Terms (auto scale down if needed)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: _isEmailVerified
                                      ? (v) => setState(
                                          () => _agreedToTerms = v ?? false,
                                        )
                                      : null,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xffDAE0EE),
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) {
                                      if (states.contains(
                                        MaterialState.selected,
                                      )) {
                                        return const Color(0xFF1D5DE5);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff717F9A),
                                      ),
                                      children: [
                                        const TextSpan(text: "I agree to the "),
                                        TextSpan(
                                          text: "Terms of Service",
                                          style: const TextStyle(
                                            color: Color(0xff28A6FF),
                                          ),
                                          recognizer: _termsRec,
                                        ),
                                        const TextSpan(text: " and "),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: const TextStyle(
                                            color: Color(0XFF28A6FF),
                                          ),
                                          recognizer: _privacyRec,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          GradientButton(
                            text: _signingUp ? "Signing Up..." : "Sign Up",
                            onPressed:
                                (_isEmailVerified &&
                                    _agreedToTerms &&
                                    !_signingUp)
                                ? _onSignup
                                : () {
                                    setState(() => _submitted = true);
                                    if (!_isEmailVerified) {
                                      _showTopError(
                                        "Please verify your email first.",
                                      );
                                    }
                                    if (!_agreedToTerms) {
                                      _showTopError(
                                        "Please accept Terms & Privacy.",
                                      );
                                    }
                                  },
                          ),

                          const SizedBox(height: 24),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(
                                  color: Color(0XFF151E2F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign in",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Color(0XFF1D5DE5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          Get.offNamed(Routes.login),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
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
          color: Color(0XFF2E3D5B),
        ),
      ),
    );
  }

  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
    required Widget suffixWidget,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final input = value.text.trim();
        if (input.isEmpty) return const Iterable<String>.empty();

        final atIndex = input.indexOf('@');
        if (atIndex < 0) {
          return _emailDomains.map((d) => '$input@$d');
        }

        final local = input.substring(0, atIndex);
        final typedDomain = input.substring(atIndex + 1).toLowerCase();
        if (local.isEmpty) return const Iterable<String>.empty();

        final matches = _emailDomains.where(
          (d) => d.toLowerCase().startsWith(typedDomain),
        );
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

          _lastEmail = controller.text.trim();

          controller.addListener(() {
            final now = controller.text.trim();
            final populated = now.isNotEmpty;

            // ✅ only reset verification if email actually changed
            if (_isEmailVerified && now != _lastEmail) {
              setState(() {
                _isEmailVerified = false;
                _verifiedOtp = null;
                _agreedToTerms = false;
              });
            }

            if (_isEmailPopulated != populated) {
              setState(() => _isEmailPopulated = populated);
            }

            _lastEmail = now;
          });
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: !_isEmailVerified,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          decoration: _inputDecoration(
            hint: hint,
            iconPath: iconPath,
            suffixWidget: suffixWidget,
            enabled: !_isEmailVerified,
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
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
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

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    Widget? suffixWidget,
    bool isPassword = false,
    bool enabled = true,
    String? suffixIconPath,
    VoidCallback? onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0XFF717F9A),
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),

      // ✅ error style + red borders
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

      // ✅ normal + focused (blue) borders
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
