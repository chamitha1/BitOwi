import 'dart:async';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

class BindTradePwdSheet extends StatefulWidget {
  final String email;
  final VoidCallback onSuccess;

  const BindTradePwdSheet({
    super.key,
    required this.email,
    required this.onSuccess,
  });

  @override
  State<BindTradePwdSheet> createState() => _BindTradePwdSheetState();
}

class _BindTradePwdSheetState extends State<BindTradePwdSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool _isPasswordObscure = true;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _canResend = true;
  bool _isSending = false;
  bool _isConfirming = false;

  @override
  void dispose() {
    _timer?.cancel();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    if (!_canResend || _isSending) return;

    setState(() => _isSending = true);

    try {
      final success = await UserApi().sendOtp(
        email: widget.email,
        bizType: SmsBizType.bindTradePwd,
      );

      if (success) {
        _startTimer();
        if (mounted) {
          CustomSnackbar.showSuccess(
            title: "Success",
            message: "OTP sent successfully",
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            title: "Error",
            message: "Failed to send OTP",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Error sending OTP: $e",
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _confirm() async {
    final pwd = _passwordController.text.trim();
    final otp = _pinController.text.trim();

    if (pwd.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter transaction password",
      );
      return;
    }
    if (otp.length != 6) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter valid OTP",
      );
      return;
    }

    setState(() => _isConfirming = true);

    try {
      await UserApi().bindTradePwd(
        email: widget.email,
        smsCode: otp,
        tradePwd: pwd,
      );

      if (mounted) {
        widget.onSuccess();
        Navigator.pop(context);
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "Transaction password set successfully",
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Failed to set password: $e",
        );
      }
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pin Theme
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xFF151E2F),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE1E1EC)),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF2F5599)),
    );

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE1E1EC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Set Transaction Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff151E2F),
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 32),

          const Text(
            "Transaction Password",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff2E3D5B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _isPasswordObscure,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Enter 6-digit password",
              hintStyle: const TextStyle(
                color: Color(0xFFB9C6E2),
                fontFamily: 'Inter',
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1D5DE5)),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordObscure = !_isPasswordObscure;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    _isPasswordObscure
                        ? 'assets/icons/forgot_password/eye-slash.svg'
                        : 'assets/icons/forgot_password/eye.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Email Verification Code",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff2E3D5B),
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: _sendOtp,
                child: Text(
                  _isSending
                      ? "Sending..."
                      : (!_canResend ? "${_secondsRemaining}s" : "Send Code"),
                  style: TextStyle(
                    color: _canResend
                        ? const Color(0xFF1D5DE5)
                        : const Color(0xFF717F9A),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Pinput(
            length: 6,
            controller: _pinController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            showCursor: true,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ElevatedButton(
                onPressed: _isConfirming ? null : _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isConfirming
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}
