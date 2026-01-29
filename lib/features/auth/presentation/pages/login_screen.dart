import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:BitOwi/features/auth/presentation/pages/signup_screen.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/features/rich_text_config.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  TextEditingController? _emailController;

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  final Color _primaryBlue = const Color(0XFF1D5DE5);

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
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return '请输入邮箱'.tr;
    if (!_emailRegex.hasMatch(email)) return '请输入有效邮箱'.tr;
    return null;
  }

  String? _validatePassword(String? value) {
    final pass = (value ?? '').trim();
    if (pass.isEmpty) return '请输入密码'.tr;
    if (pass.length < 6) return '密码至少6位'.tr;
    return null;
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiClient.dio.post(
        '/core/v1/cuser/public/login',
        data: {
          'loginName': _emailController?.text.trim(),
          'loginPwd': _passwordController.text,
        },
      );
      final dynamic rawData = response.data;

      final Map<String, dynamic> data = rawData is String
          ? jsonDecode(rawData)
          : rawData;

      // ignore: avoid_print
      AppLogger.d('Login response: $data');

      if (data['code'] == 200 || data['code'] == '200') {
        final tokenData = data['data'] as Map<String, dynamic>;
        final token = tokenData['token'] as String? ?? '';

        await StorageService.saveToken(token);

        await StorageService.saveUserName(_emailController?.text.trim() ?? '');
        await StorageService.saveRememberMe(_rememberMe);

        final userId = tokenData['userId'] as String? ?? '';
        await StorageService.saveUserId(userId);

        AppLogger.d('Token saved: $token');

        if (!mounted) return;

        // Refresh user data in the global controller
        await UserController.to.loadUser();

        await UserController.to.initIMForCurrentUser();

        Get.offAllNamed(Routes.home);
      } else {
        throw 'Login failed: ${data['errorMsg'] ?? 'Unknown'}';
      }
    } catch (e) {
      AppLogger.d('Login error: $e');
      final msg = _extractBackendError(e);
      CustomSnackbar.showError(title: 'Login Failed', message: msg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractBackendError(dynamic e) {
    try {
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          final msg = data["errorMsg"] ?? data["message"] ?? data["msg"];
          if (msg != null) return msg.toString();
        }
        return e.message ?? "Login failed";
      }
    } catch (_) {}

    return e.toString().replaceFirst("Exception: ", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 56),

                        Text(
                          'Welcome Back to Sign in'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Color(0XFF151E2F),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Your account is protected with encrypted login and advanced authentication.'
                              .tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff717F9A),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildLabel('Email'.tr),
                        _emailAutocompleteField(
                          hint: 'Enter your email'.tr,
                          iconPath: 'assets/icons/login/sms.svg',
                        ),

                        const SizedBox(height: 20),

                        _buildLabel('Password'.tr),
                        _textField(
                          controller: _passwordController,
                          hint: 'Enter Password'.tr,
                          iconPath: 'assets/icons/login/lock.svg',
                          isPassword: true,
                          suffixIconPath: _obscurePassword
                              ? 'assets/icons/login/eye.svg'
                              : 'assets/icons/sign_up/eye-slash.svg',
                          validator: _validatePassword,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                                activeColor: _primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                            const SizedBox(width: 8),

                            Text(
                              'Remember me'.tr,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF454F63),
                              ),
                            ),

                            const Spacer(),

                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ForgotPasswordScreen());
                              },
                              child: Text(
                                'Forgot Password?'.tr,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Color(0XFF1D5DE5),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            // gradient: const LinearGradient(
                            //   colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            // ),
                            color: Color(0xff1D5DE5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    '登录'.tr,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFFFFFFFF),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Color(0XFF151E2F),
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(text: "Don't have an account? ".tr),
                                TextSpan(
                                  text: 'Sign up'.tr,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color(0XFF1D5DE5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.offNamed(Routes.signup);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),
                        // terms and privacy
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runSpacing: 4,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => RichTextConfig(
                                            title: "Terms & Condition",
                                            configKey:
                                                "registered_agreement_textarea",
                                            configType: "system",
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Terms & Condition",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0XFF28A6FF),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " and ",
                                      style: const TextStyle(
                                        color: Color(0xff717F9A),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => RichTextConfig(
                                            title: "Privacy Policy",
                                            configKey:
                                                "privacy_agreement_textarea",
                                            configType: "system",
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Privacy Policy",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0XFF28A6FF),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
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

  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final input = value.text.trim();

        if (input.isEmpty) return const Iterable<String>.empty();

        // if already complete email with domain, stop suggestions
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
        // re-validate after selecting an option
        _formKey.currentState?.validate();
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_emailController != controller) {
          _emailController = controller;
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(hint: hint, iconPath: iconPath),
          validator: _validateEmail,
          onChanged: (_) => _formKey.currentState?.validate(),
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            color: const Color(0XFFF6F9FF),
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 600),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(opt),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
    bool isPassword = false,
    String? suffixIconPath,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0XFFFFFFFF),
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0XFF717F9A),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0XFFDAE0EE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryBlue, width: 1.5),
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
        padding: const EdgeInsets.all(13.5),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            Color(0XFF717F9A),
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: isPassword && suffixIconPath != null
          ? IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  suffixIconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0XFF2E3D5B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: Color(0xff2E3D5B),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    bool isPassword = false,
    String? suffixIconPath,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: _inputDecoration(
        hint: hint,
        iconPath: iconPath,
        isPassword: isPassword,
        suffixIconPath: suffixIconPath,
      ),
      validator: validator,
    );
  }

  Widget _socialButton(String imagePath) {
    return Expanded(
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: const Color(0Xff343558).withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Image.asset(imagePath, height: 24, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
