import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/gradient_button.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final userApi = UserApi();

  late TextEditingController _emailController;

  FocusNode? _autocompleteFocusNode;

  bool _isPasswordVisible = false;
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;
  String? _passwordErrorText;
  bool _isSendingOtp = false;

  static const List<String> _emailDomains = <String>[
    'gmail.com',
    'hotmail.com',
    'outlook.com',
    'yahoo.com',
    'icloud.com',
    'live.com',
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0XFF151E2F),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
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
                suffixWidget: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: _verifyButton(
                    text: _isEmailVerified ? "Verified" : "Verify",
                    isEnabled: _isEmailPopulated,
                    isVerified: _isEmailVerified,

                    onPressed: () async {
                      if (_isEmailPopulated) {
                        _autocompleteFocusNode?.unfocus();
                        FocusScope.of(context).unfocus();

                        setState(() => _isSendingOtp = true);

                        final bool response = await userApi.sendOtp(
                          email: _emailController.text.trim(),
                          bizType: SmsBizType.forgetPwd,
                        );

                        setState(() => _isSendingOtp = false);

                        print('OTP sent response: $response');

                        if (response == true) {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: const Color(
                              0xFFECEFF5,
                            ).withOpacity(0.7),
                            builder: (context) => OtpBottomSheet(
                              email: _emailController.text.trim(),
                              otpLength: 6,
                              bizType: SmsBizType.forgetPwd,

                              onVerifyPin: (pin) async {
                                // return await userApi.verifyOtp(
                                //   email: _emailController.text.trim(),
                                //   bizType: SmsBizType.forgetPwd,
                                //   smsCode: pin,
                                // );
                                return true;
                              },

                              onResend: () async {
                                return await userApi.sendOtp(
                                  email: _emailController.text.trim(),
                                  bizType: SmsBizType.forgetPwd,
                                );
                              },

                              onVerified: () {
                                Navigator.pop(context);
                                setState(() => _isEmailVerified = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Email Verified Successfully!",
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed to send OTP. Please try again.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _textLabel("New Password"),
              TextField(
                controller: _passController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Enter New Password",
                  iconPath: "assets/icons/sign_up/lock.svg",
                  suffixIconPath: !_isPasswordVisible
                      ? "assets/icons/sign_up/eye.svg"
                      : "assets/icons/sign_up/eye-slash.svg",
                  isPassword: true,
                  enabled: _isEmailVerified,
                  borderColor: _passwordErrorText != null
                      ? const Color(0xFFE74C3C)
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              _textLabel("Confirm Password"),
              TextField(
                controller: _confirmPassController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Re-Enter New Password",
                  iconPath: "assets/icons/sign_up/lock.svg",
                  suffixIconPath: !_isPasswordVisible
                      ? "assets/icons/sign_up/eye.svg"
                      : "assets/icons/sign_up/eye-slash.svg",
                  isPassword: true,
                  enabled: _isEmailVerified,
                  errorText: _passwordErrorText,
                ),
              ),
              const SizedBox(height: 40),

              GradientButton(
                text: "Update",
                onPressed: _isEmailVerified
                    ? () {
                        setState(() {
                          if (_passController.text !=
                              _confirmPassController.text) {
                            _passwordErrorText = "Passwords do not match";
                          } else {
                            _passwordErrorText = null;
                            // Handle Update
                          }
                        });
                      }
                    : () {},
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
        color: Color(0xff717F9A),
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
          color: borderColor ?? const Color.fromARGB(255, 112, 152, 221),
          width: 1.0,
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
            ? const Color(0xff2ECC71)
            : (isEnabled ? null : const Color(0XFFB9C6E2)),
        gradient: (isEnabled && !isVerified)
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
              )
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: (isEnabled && !isVerified) ? onPressed : null,
        child: isVerified
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/sign_up/check_circle.png",
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white,
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
    );
  }

  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
    required Widget suffixWidget,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final raw = value.text;
        final input = raw.trim();

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
        _emailController.text = selection;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: selection.length),
        );
        setState(() {
          _isEmailPopulated = true;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_emailController != controller) {
          _emailController = controller;
          _autocompleteFocusNode = focusNode;

          _emailController!.addListener(() {
            setState(() {
              _isEmailPopulated = _emailController!.text.isNotEmpty;
            });
          });
        }
        return TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(
            hint: hint,
            iconPath: iconPath,
            suffixWidget: suffixWidget,
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
}
