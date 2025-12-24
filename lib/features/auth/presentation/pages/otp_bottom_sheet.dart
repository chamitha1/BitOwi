import 'dart:async';
import 'package:BitDo/constants/sms_constants.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpBottomSheet extends StatefulWidget {
  final String email;
  final int otpLength;
  final SmsBizType bizType;

  /// ✅ REQUIRED: parent provides OTP validation (API)
  final Future<bool> Function(String pin) onVerifyPin;

  /// ✅ called when verification is successful
  final VoidCallback onVerified;

  /// ✅ optional: parent provides resend OTP (API)
  final Future<bool> Function()? onResend;

  const OtpBottomSheet({
    super.key,
    required this.email,
    required this.bizType,
    required this.onVerifyPin,
    required this.onVerified,
    this.onResend,
    this.otpLength = 6,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _pinController = TextEditingController();

  int _secondsRemaining = 35;
  Timer? _timer;
  bool _canResend = false;

  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 35;
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

  String get _obfuscatedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;

    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return widget.email;

    final firstLetter = name.substring(0, 1);
    final lastLetter = name.substring(name.length - 1);
    final stars = '*' * (name.length - 2);
    return '$firstLetter$stars$lastLetter@$domain';
  }

  Future<void> _verify() async {
    final pin = _pinController.text.trim();

    if (pin.length != widget.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid OTP")),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final ok = await widget.onVerifyPin(pin);
      if (!mounted) return;

      if (ok) {
        widget.onVerified();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP, please try again.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verification failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resend() async {
    if (!_canResend || _isResending) return;

    setState(() => _isResending = true);

    try {
      if (widget.onResend != null) {
        final ok = await widget.onResend!();
        if (!mounted) return;

        if (ok) {
          _startTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP resent successfully.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to resend OTP. Try again.")),
          );
        }
      } else {
        // no resend api passed
        _startTimer();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resend failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: widget.otpLength == 6 ? 45 : 56,
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
        children: [
          const SizedBox(height: 16),
          Image.asset(
            "assets/icons/verify_email/shield.png",
            height: 64,
            width: 64,
          ),
          const SizedBox(height: 24),
          const Text(
            "Enter Verification Code",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff151E2F),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Verification code has been send to\n$_obfuscatedEmail",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff454F63),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          Pinput(
            length: widget.otpLength,
            controller: _pinController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            showCursor: true,
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1D5DE5), Color(0xFF174AB7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Didn’t receive code? ",
                style: TextStyle(
                  color: Color(0xff313832),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              // GestureDetector(
              //   onTap: (_canResend && !_isResending) ? _resend : null,
              //   child: Text(
              //     _isResending ? "Resending..." : "Resend OTP",
              //     style: TextStyle(
              //       color: _canResend ? const Color(0xff6545D0) : Colors.grey,
              //       fontWeight: FontWeight.w400,
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: (_canResend && !_isResending) ? _resend : null,
                child: Text(
                  _isResending ? "Resending..." : "Resend OTP",
                  style: const TextStyle(
                    color: Color(0xFF1D5DE5),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!_canResend)
                Text(
                  " 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xff313832),
                    fontSize: 14,
                  ),
                ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}
