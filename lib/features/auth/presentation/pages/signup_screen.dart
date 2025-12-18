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
  // Controllers
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteController = TextEditingController();

  // Email dropdown sizing
  final GlobalKey _emailFieldKey = GlobalKey();

  // State Variables
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;

  // Logic States
  bool _isEmailPopulated = false;
  bool _isEmailVerified = false;

  // Theme Color
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
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final nowPopulated = _emailController.text.trim().isNotEmpty;
      if (nowPopulated != _isEmailPopulated) {
        setState(() => _isEmailPopulated = nowPopulated);
      }
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

  void _openOtpSheet() {
    if (!_isEmailPopulated) return;

    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xffECEFF5).withOpacity(0.7),
      builder: (context) => OtpBottomSheet(
        email: _emailController.text.trim(),
        onVerified: () {
          Navigator.pop(context);
          setState(() => _isEmailVerified = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email Verified Successfully!")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
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
                      text: "Verify",
                      isEnabled: _isEmailPopulated,
                      onPressed: () {
                        if (_isEmailPopulated) {
                          // Close keyboard first
                          FocusScope.of(context).unfocus();

                          // SHOW THE BOTTOM SHEET
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // Allows the sheet to rise with keyboard
                            backgroundColor: Colors
                                .transparent, // Let the sheet define its own corners
                            barrierColor: Color(0xffECEFF5).withOpacity(0.7),
                            builder: (context) => OtpBottomSheet(
                              email: _emailController
                                  .text, // Pass the actual email typed
                              onVerified: () {
                                // Close the bottom sheet
                                Navigator.pop(context);

                                // Update state in parent screen
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
                          ? (v) => setState(() => _agreedToTerms = v ?? false)
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
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0XFF454F63),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        children: const [
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

              GradientButton(
                text: "Sign Up",
                onPressed: _isEmailVerified && _agreedToTerms
                    ? () {
                        // sign up logic
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

  // ---------- Email Autocomplete Field (Styled) ----------
  Widget _emailAutocompleteField({
    required String hint,
    required String iconPath,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final input = value.text.trim();
        if (input.isEmpty) return const Iterable<String>.empty();

        final at = input.indexOf('@');

        if (at < 0) {
          // No '@' typed
          return _emailDomains.map((d) => '$input@$d');
        }

        // With '@' typed
        final local = input.substring(0, at).trim();
        final typedDomain = input.substring(at + 1).toLowerCase();

        if (local.isEmpty) return const Iterable<String>.empty();

        final matches = _emailDomains.where((d) => d.toLowerCase().startsWith(typedDomain));
        return matches.map((d) => '$local@$d');
      },

      onSelected: (selection) {
        _emailController.text = selection;
        _emailController.selection = TextSelection.fromPosition(
          TextPosition(offset: selection.length),
        );
        setState(() => _isEmailPopulated = selection.trim().isNotEmpty);
      },

      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        // IMPORTANT: bind Autocomplete controller to our controller
        // so Verify reads correct email.
        if (controller.text != _emailController.text) {
          controller.text = _emailController.text;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }

        controller.addListener(() {
          if (_emailController.text != controller.text) {
            _emailController.text = controller.text;
            _emailController.selection = controller.selection;
          }
        });

        return Container(
          key: _emailFieldKey,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              hint: hint,
              iconPath: iconPath,
              suffix: Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                child: _verifyButton(
                  text: "Verify",
                  isEnabled: _isEmailPopulated,
                  onPressed: _openOtpSheet,
                ),
              ),
            ),
            onSubmitted: (_) => onFieldSubmitted(),
          ),
        );
      },

      optionsViewBuilder: (context, onSelected, options) {
        // dropdown same width as field
        double width = MediaQuery.of(context).size.width - 48;
        final box = _emailFieldKey.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) width = box.size.width;

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDAE0EE), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0XFF343558).withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 1,
                      color: const Color(0xFFDAE0EE).withOpacity(0.7),
                    ),
                    itemBuilder: (context, index) {
                      final opt = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(opt),
                        splashColor: _primaryBlue.withOpacity(0.08),
                        highlightColor: _primaryBlue.withOpacity(0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.alternate_email, size: 18, color: Color(0XFF717F9A)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  opt,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14.5,
                                    color: Color(0XFF151E2F),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- helper widgets ----------
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
      hintStyle: const TextStyle(
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
                    ? () => setState(() => _isPasswordVisible = !_isPasswordVisible)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    suffixIconPath,
                    width: 20,
                    height: 20,
                    color: _isPasswordVisible ? const Color.fromARGB(255, 15, 40, 59) : null,
                  ),
                ),
              ),
            )
          : suffix,
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
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1D5DE5), width: 1.5),
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
