import 'package:BitDo/core/widgets/gradient_button.dart';
import 'package:BitDo/features/auth/presentation/pages/login_screen.dart';
import 'package:BitDo/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteController = TextEditingController();

  // State Variables
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;

  // Logic States
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isEmailPopulated = _emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(
                  hint: "Enter your email",
                  iconPath: "assets/icons/sign_up/sms.png",
                  suffix: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: _verifyButton(
                      text: _isEmailVerified ? "Verified" : "Verify",
                      isVerified: _isEmailVerified,
                      isEnabled: _isEmailPopulated,
                      onPressed: () {
                        if (_isEmailPopulated) {
                          FocusScope.of(context).unfocus();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Color(0xffECEFF5).withOpacity(0.7),
                            builder: (context) => OtpBottomSheet(
                              email: _emailController.text,
                              onVerified: () {
                                Navigator.pop(context);

                                setState(() {
                                  _isEmailVerified = true;
                                });
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
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _textLabel("Password"),
              TextField(
                controller: _passController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Enter Password",
                  iconPath: "assets/icons/sign_up/lock.png",
                  suffixIconPath: "assets/icons/sign_up/eye.png",
                  isPassword: true,
                ),
              ),
              const SizedBox(height: 30),

              _textLabel("Confirm Password"),
              TextField(
                controller: _confirmPassController,
                enabled: _isEmailVerified,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Re-Enter Password",
                  iconPath: "assets/icons/sign_up/lock.png",
                  isPassword: true,
                  suffixIconPath: "assets/icons/sign_up/eye.png",
                ),
              ),
              const SizedBox(height: 30),

              _textLabel("Invitation Code (optional)"),
              TextField(
                controller: _inviteController,
                enabled: _isEmailVerified,
                decoration: _inputDecoration(
                  hint: "Please Enter Your Code",
                  iconPath: "assets/icons/sign_up/hashtag.png",
                ),
              ),
              const SizedBox(height: 22),

              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: _isEmailVerified
                          ? (v) => setState(() => _agreedToTerms = v!)
                          : null,
                      activeColor: const Color(0xFF2F5599),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I agree to the ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0XFF454F63),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF28A6FF),
                            ),
                          ),
                          TextSpan(
                            text: " and ",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF454F63),
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF28A6FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //Sign up button
              GradientButton(
                text: "Sign Up",
                onPressed: _isEmailVerified && _agreedToTerms
                    ? () {
                        //sign up logic
                      }
                    : () {},
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
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0XFF1D5DE5),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Navigate to login
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
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

  // helper widgets

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

  InputDecoration _inputDecoration({
    required String hint,
    required String iconPath,
    Widget? suffix,
    bool isPassword = false,
    bool enabled = true,
    String? suffixIconPath,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Color(0XFF717F9A),
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),

      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(iconPath, width: 20, height: 20),
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
                  child: Image.asset(
                    suffixIconPath,
                    width: 20,
                    height: 20,
                    color: _isPasswordVisible
                        ? const Color.fromARGB(255, 15, 40, 59)
                        : null,
                  ),
                ),
              ),
            )
          : suffix,
      filled: true,
      //ternery doesn't work so had to force color using MaterialState
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color(0xFFECEFF5);
        }
        return Colors.white;
      }),

      contentPadding: const EdgeInsets.symmetric(vertical: 12),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
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
          padding: EdgeInsets.symmetric(horizontal: isVerified ? 8 : 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.white,
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
                  ),
                  const SizedBox(width: 4),
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
}
