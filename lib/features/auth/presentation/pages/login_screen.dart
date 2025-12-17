import 'package:BitDo/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final Color _primaryBlue = const Color(0XFF1D5DE5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Text(
                'Welcome Back to Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: const Color(0XFF151E2F),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your account is protected with encrypted login and advanced authentication.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0XFF454F63),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),

              _buildLabel('Email'),
              _textField(
                controller: _emailController,
                hint: 'Enter your email',
                iconPath: 'assets/icons/login/sms.png',
              ),
              const SizedBox(height: 20),

              _buildLabel('Password'),
              _textField(
                controller: _passwordController,
                hint: 'Enter Password',
                iconPath: 'assets/icons/login/lock.png',
                isPassword: true,
                suffixIconPath: 'assets/icons/login/eye.png',
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v!),
                      activeColor: _primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remind me',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF454F63),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFFFFFFFF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0XFF454F63),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  // Pass your asset paths here
                  _socialButton('assets/images/login/tbay_logo.png'),
                  const SizedBox(width: 14),
                  _socialButton('assets/images/login/cardgoal_logo.png'),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Color(0XFF151E2F),
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0XFF1D5DE5),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 90),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0XFF28A6FF),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      const TextSpan(text: "Terms & Condition"),
                      TextSpan(
                        text: " and ",
                        style: TextStyle(
                          color: Color(0XFF454F63),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: "Privacy Policy"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // helper widgets

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: Color(0XFF2E3D5B),
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
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0XFFFFFFFF),
        hintText: hint,
        hintStyle: TextStyle(
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
        prefixIcon: Padding(
          padding: const EdgeInsets.all(
            13.5,
          ),
          child: Image.asset(
            iconPath,
            width: 24, 
            height: 24,
            fit: BoxFit.contain,
            color: Color(0XFF717F9A),
          ),
        ),

     
        suffixIcon: isPassword && suffixIconPath != null
            ? IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    suffixIconPath,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  
                    color: _obscurePassword
                        ? Color(0XFF2E3D5B)
                        : const Color.fromARGB(255, 145, 176, 250),
                  ),
                ),
              )
            : null,
      ),
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
              color: Color(0Xff343558).withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Image.asset(
              imagePath,
              height: 24, 
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
