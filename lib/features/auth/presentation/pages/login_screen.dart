import 'package:BitDo/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  TextEditingController? _emailController;

  bool _obscurePassword = true;
  bool _rememberMe = false;

  final Color _primaryBlue = const Color(0XFF1D5DE5);

  static const List<String> _emailDomains = <String>[
    'gmail.com',
    'hotmail.com',
    'outlook.com',
    'yahoo.com',
    'icloud.com',
    'live.com',
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Welcome Back to Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF151E2F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
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
              _emailAutocompleteField(
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
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                      activeColor: _primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
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
                      // TODO: forgot password
                    },
                    child: const Text(
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
                    final email = (_emailController?.text ?? '').trim();
                    final pass = _passwordController.text;

                    debugPrint('Email: $email');
                    debugPrint('Pass: $pass');

                    // call login API
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                  _socialButton('assets/images/login/tbay_logo.png'),
                  const SizedBox(width: 14),
                  _socialButton('assets/images/login/cardgoal_logo.png'),
                ],
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
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(
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
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0XFF28A6FF),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(text: "Terms & Condition"),
                      TextSpan(
                        text: " and ",
                        style: TextStyle(
                          color: Color(0XFF454F63),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "Privacy Policy"),
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

  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final raw = value.text;
        final input = raw.trim();

        if (input.isEmpty) return const Iterable<String>.empty();
        if (_emailDomains.any((d) => input.toLowerCase() == '${_localPart(input).toLowerCase()}@$d')) {
          return const Iterable<String>.empty();
        }

        final atIndex = input.indexOf('@');

        if (atIndex < 0) {
          
          if (input.isEmpty) return const Iterable<String>.empty();
          return _emailDomains.map((d) => '$input@$d');
        }

        final local = input.substring(0, atIndex);
        final typedDomain = input.substring(atIndex + 1).toLowerCase();

        if (local.isEmpty) return const Iterable<String>.empty();

        final matches = _emailDomains.where((d) => d.toLowerCase().startsWith(typedDomain));
        return matches.map((d) => '$local@$d');
      },
      onSelected: (String selection) {
        _emailController?.text = selection;
        _emailController?.selection = TextSelection.fromPosition(
          TextPosition(offset: selection.length),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_emailController != controller) {
          _emailController?.dispose();
          _emailController = controller;
        }

        return TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(
            hint: hint,
            iconPath: iconPath,
          ),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 600),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(opt),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      prefixIcon: Padding(
        padding: const EdgeInsets.all(13.5),
        child: Image.asset(
          iconPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          color: const Color(0XFF717F9A),
        ),
      ),
      suffixIcon: isPassword && suffixIconPath != null
          ? IconButton(
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  suffixIconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: _obscurePassword
                      ? const Color(0XFF2E3D5B)
                      : const Color.fromARGB(255, 145, 176, 250),
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
      decoration: _inputDecoration(
        hint: hint,
        iconPath: iconPath,
        isPassword: isPassword,
        suffixIconPath: suffixIconPath,
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
              color: const Color(0Xff343558).withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // TODO: social login
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
