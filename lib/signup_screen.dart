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

  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Set up your profile with strong protection for safe crypto trading and storage.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              _textLabel("Email"),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(
                  hint: "Enter your email",
                  prefixIcon: Icons.email_outlined,

                  suffixIcon: _verifyButton("Verify", onPressed: () {}),
                ),
              ),
              const SizedBox(height: 16),
              _textLabel("Password"),
              TextField(
                controller: _passController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Enter Password",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _textLabel("Confirm Password"),
              TextField(
                controller: _confirmPassController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  hint: "Re-Enter Password",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _textLabel("Invitation Code (optional)"),
              TextField(
                controller: _inviteController,
                decoration: _inputDecoration(
                  hint: "Please Enter Your Code",
                  prefixIcon: Icons.tag,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (v) => setState(() => _agreedToTerms = v!),
                    activeColor: const Color(0xFF2F5599),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I agree to the ",
                        style: const TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  //Widgets for verify button, text labels and input text styles/decoration

  Widget _textLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: Colors.grey[400], size: 20),
      suffix: suffix,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F6FA), // Light grey background
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // No border line by default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _verifyButton(String text, {required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFFD0D5DD,
          ), // Greyish disabled look initially
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
