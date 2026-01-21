import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

void showCommonConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String primaryText = "Confirm",
  String secondaryText = "Cancel",
  required VoidCallback onPrimary,
  VoidCallback? onSecondary,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CommonConfirmDialog(
      title: title,
      message: message,
      primaryText: primaryText,
      secondaryText: secondaryText,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
    ),
  );
}

class CommonConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

  const CommonConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.primaryText = "Confirm",
    this.secondaryText = "Cancel",
    required this.onPrimary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),

            /// 🔹 Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),

            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF717F9A)),
              ),
            ],

            const SizedBox(height: 24),

            /// 🔹 Primary Button (Full Width)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPrimary();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5DE5),
                  disabledBackgroundColor: const Color(0xFFB9C6E2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  primaryText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 Secondary Button (Text only)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSecondary?.call();
              },
              child: AppText.p2Medium(secondaryText, color: Color(0xFF717F9A)),
            ),
          ],
        ),
      ),
    );
  }
}
