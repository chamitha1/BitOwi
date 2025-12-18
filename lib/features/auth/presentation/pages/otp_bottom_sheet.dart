import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpBottomSheet extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const OtpBottomSheet({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _pinController = TextEditingController();
  int _secondsRemaining = 35;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = 35;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  // Helper to hide email characters ( t****s@gmail.com)
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

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
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
            length: 4,
            controller: _pinController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) {},
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
                onPressed: () {
                  //correct pin
                  widget.onVerified();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
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
              GestureDetector(
                onTap: _canResend
                    ? () {
                        //resend pin
                        startTimer();
                      }
                    : null,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: _canResend ? const Color(0xff6545D0) : Colors.grey,
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
