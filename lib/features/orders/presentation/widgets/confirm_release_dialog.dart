import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ConfirmReleaseDialog extends StatefulWidget {
  final Function(String pin) onConfirm;

  const ConfirmReleaseDialog({super.key, required this.onConfirm});

  @override
  State<ConfirmReleaseDialog> createState() => _ConfirmReleaseDialogState();
}

class _ConfirmReleaseDialogState extends State<ConfirmReleaseDialog> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pin Theme
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF151E2F),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF151E2F)),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF151E2F)),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              "Confirm Release",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Warning Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF4F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF5B7B1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/orders/info-circle.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFCF4436),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Please confirm that you have received full payment. If confirmed, then enter your transaction password to release assets.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFCF4436),
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Password Input Label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717F9A),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Pinput Field
            Pinput(
              controller: _pinController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              obscureText: true,
              obscuringWidget: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              showCursor: false,
              onCompleted: (pin) {},
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: Color(0xFF1D5DE5),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D5DE5),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_pinController.text.length == 6) {
                        Get.back();
                        widget.onConfirm(_pinController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5DE5),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
