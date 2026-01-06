import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/gradient_button.dart';
import 'package:BitOwi/features/auth/presentation/pages/login_screen.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/features/rich_text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController? _emailController;

  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteController = TextEditingController();

  final userApi = UserApi();

  FocusNode? _autocompleteFocusNode;

  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;

  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  bool _termsError = false;

  String? _verifiedOtp; // Store captured OTP

  bool _sendingOtp = false;
  bool _signingUp = false;

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
    // _emailController is managed by Autocomplete
  }

  @override
  void dispose() {
    // _emailController.dispose(); // Managed by Autocomplete
    _passController.dispose();
    _confirmPassController.dispose();
    _inviteController.dispose();
    super.dispose();
  }



  bool _validateEmailLocal() {
    final email = _emailController?.text.trim() ?? "";
    if (email.isEmpty) {
      setState(() => _emailErrorText = "Please enter your email");
      return false;
    }
    if (!_emailRegex.hasMatch(email)) {
      setState(() => _emailErrorText = "Invalid email format");
      return false;
    }
    setState(() => _emailErrorText = null);
    return true;
  }

  bool _validatePasswordsLocal() {
    final pass = _passController.text.trim();
    final confirm = _confirmPassController.text.trim();
    bool isValid = true;

    // Validate Password
    if (pass.isEmpty) {
      setState(() => _passwordErrorText = "Please enter password");
      isValid = false;
    } else if (pass.length < 6) {
      setState(
        () => _passwordErrorText = "Password must be at least 6 characters",
      );
      isValid = false;
    } else {
      setState(() => _passwordErrorText = null);
    }

    // Validate Confirm Password
    if (confirm.isEmpty) {
      setState(() => _confirmPasswordErrorText = "Please confirm password");
      isValid = false;
    } else if (confirm != pass) {
      setState(() => _confirmPasswordErrorText = "Passwords do not match");
      isValid = false;
    } else {
      setState(() => _confirmPasswordErrorText = null);
    }

    return isValid;
  }

  Future<void> _openOtpSheet() async {
    if (_sendingOtp) return;

    FocusScope.of(context).unfocus();
    _autocompleteFocusNode?.unfocus();

    if (!_validateEmailLocal()) return;

      final email = _emailController!.text.trim();

    setState(() => _sendingOtp = true);

    try {
      final success = await userApi.sendOtp(
        email: email,
        bizType: SmsBizType.register,
      );

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

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: const Color(0xFFECEFF5).withOpacity(0.7),
        builder: (context) => OtpBottomSheet(
          email: _emailController!.text.trim(),
          otpLength: 6,
          bizType: SmsBizType.register,

          // ✅ API verify here (replace with your real endpoint)
          onVerifyPin: (pin) async {
            // return await userApi.verifyOtp(
            //   email: _emailController.text.trim(),
            //   bizType: SmsBizType.register,
            //   smsCode: pin,
            // );

            // Store the OTP entered by the user
            _verifiedOtp = pin;
            return true; // Proceed with this OTP
          },

          // ✅ resend api
          onResend: () async {
            return await userApi.sendOtp(
              email: _emailController!.text.trim(),
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
      CustomSnackbar.showError(title: "Error", message: "OTP send failed: $e");
    } finally {
      if (mounted) setState(() => _sendingOtp = false);
    }
  }

  Future<void> _onSignup() async {
    if (_signingUp) return;

    FocusScope.of(context).unfocus();

    if (!_validateEmailLocal()) return;

    if (!_isEmailVerified) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please verify your email first",
      );
      return;
    }
    final bool passwordsValid = _validatePasswordsLocal();
    bool termsValid = true;

    if (!_agreedToTerms) {
      setState(() => _termsError = true);
      termsValid = false;
      CustomSnackbar.showError(
        title: "Error",
        message: "Please read and accept Terms & Privacy",
      );
    }

    if (!passwordsValid || !termsValid) return;

    setState(() => _signingUp = true);

    try {
      final resData = await userApi.signup(
        email: _emailController!.text.trim(),
        smsCode: _verifiedOtp ?? "", // Use captured OTP
        loginPwd: _passController.text.trim(),
        inviteCode: _inviteController.text.trim().isEmpty
            ? null
            : _inviteController.text.trim(),
      );

      print('Signup response: $resData');

      if (resData['code'] == 200 || resData['code'] == '200') {
        final tokenData = resData['data'] as Map<String, dynamic>;
        final token = tokenData['token'] as String? ?? '';

        await StorageService.saveToken(token);
        await StorageService.saveUserName(_emailController!.text.trim());

        if (!mounted) return;

        Get.offAllNamed(Routes.home);
      } else {
        CustomSnackbar.showError(title: "Error", message: "Signup failed: ${resData['errorMsg']}");
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(title: "Error", message: "Signup failed: $e");
    } finally {
      if (mounted) setState(() => _signingUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  color: Color(0XFF454F63),
                ),
              ),
              const SizedBox(height: 28),

              _textLabel("Email"),
              _emailAutocompleteField(
                hint: "Enter your email",
                iconPath: "assets/icons/sign_up/sms.svg",
                suffixWidget: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
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
              TextField(
                controller: _passController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                onChanged: (_) {
                  if (_passwordErrorText != null) _validatePasswordsLocal();
                },
                decoration: _inputDecoration(
                  hint: "Enter Password",
                  iconPath: "assets/icons/sign_up/lock.svg",
                  suffixIconPath: !_isPasswordVisible
                      ? "assets/icons/sign_up/eye.svg"
                      : "assets/icons/sign_up/eye-slash.svg",
                  isPassword: true,
                  enabled: _isEmailVerified,
                  errorText: _passwordErrorText,
                ),
              ),
              const SizedBox(height: 30),

              _textLabel("Confirm Password"),
              TextField(
                controller: _confirmPassController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                onChanged: (_) {
                  if (_confirmPasswordErrorText != null) _validatePasswordsLocal();
                },
                decoration: _inputDecoration(
                  hint: "Re-Enter Password",
                  iconPath: "assets/icons/sign_up/lock.svg",
                  suffixIconPath: !_isPasswordVisible
                      ? "assets/icons/sign_up/eye.svg"
                      : "assets/icons/sign_up/eye-slash.svg",
                  isPassword: true,
                  enabled: _isEmailVerified,
                  errorText: _confirmPasswordErrorText,
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _agreedToTerms
                              ? Colors.transparent
                              : (_termsError
                                  ? const Color(0xFFE74C3C)
                                  : const Color(0xFFC0C0C0)),
                          width: 1.0,
                        ),
                      ),
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: _isEmailVerified
                            ? (v) => setState(() {
                                  _agreedToTerms = v ?? false;
                                  if (_agreedToTerms) _termsError = false;
                                })
                            : null,
                        activeColor: const Color(0xFF2F5599),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // terms and privacy
                  Expanded(
                    child: Wrap(
                      runSpacing: 2,
                      children: [
                        Text(
                          "I agree to the ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFF454F63),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => RichTextConfig(
                                title: "Terms & Condition",
                                configKey: "registered_agreement_textarea",
                                configType: "system",
                              ),
                            );
                          },
                          child: Text(
                            "Terms of Service",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF28A6FF),
                            ),
                          ),
                        ),
                        Text(
                          " and ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFF454F63),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => RichTextConfig(
                                title: "Privacy Policy",
                                configKey: "privacy_agreement_textarea",
                                configType: "system",
                              ),
                            );
                          },
                          child: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF28A6FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GradientButton(
                text: _signingUp ? "Signing Up..." : "Sign Up",
                onPressed: () {
                  _onSignup();
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
                          ..onTap = () {
                            Get.offNamed(Routes.login);
                          },
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
    );
  }

  // widgets

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
          _isEmailPopulated = true;
          _emailErrorText = null;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_emailController != controller) {
          _emailController = controller;
          _autocompleteFocusNode = focusNode;
          
          _emailController!.addListener(() {
             final t = _emailController!.text.trim();
             final populated = t.isNotEmpty;
             if (_isEmailPopulated != populated) {
               setState(() => _isEmailPopulated = populated);
             }

             if (_isEmailVerified && populated) {
               // Only reset if user changes email
                // Note: this listener fires on build too often, need care?
                // Actually simplicity: if verified but text changed (and text matches expectation?)
                // Here we just replicate old logic: if text changed, unverify.
               setState(() => _isEmailVerified = false);
             }
          });
        }

        return TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: !_isEmailVerified,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            if (_emailErrorText != null) _validateEmailLocal();
          },
          decoration: _inputDecoration(
            hint: hint,
            iconPath: iconPath,
            suffixWidget: suffixWidget,
            errorText: _emailErrorText,
            enabled: !_isEmailVerified,
          ),
          onSubmitted: (_) => onFieldSubmitted(),
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
                separatorBuilder: (_, _) => const SizedBox.shrink(),
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

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    Widget? suffixWidget,
    bool isPassword = false,
    bool enabled = true,
    String? suffixIconPath,
    String? errorText,
    Color? borderColor,
  }) {
    return InputDecoration(
      errorText: errorText,
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
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0XFF717F9A),
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor ?? const Color(0xFFDAE0EE),
          width: 1.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor ?? const Color(0xFF1D5DE5),
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor ?? const Color(0xFFDAE0EE),
          width: 1.0,
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
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 30,
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
          padding: EdgeInsets.symmetric(horizontal: isVerified ? 12 : 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
