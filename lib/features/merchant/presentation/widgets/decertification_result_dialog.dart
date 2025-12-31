import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DecertificationResult { success, failed }

void showDecertificationResultDialog(
  BuildContext context, {
  required DecertificationResult result,
  String? errorMsg,
  VoidCallback? onCustomerCare,
}) {
  final bool isSuccess = result == DecertificationResult.success;

  final String description = isSuccess
      ? "Your frozen assets will be released within 24 hours and the ads function has been disabled. We look forward to welcoming you back as a merchant whenever you're ready."
      : (errorMsg != null && errorMsg.trim().isNotEmpty)
      ? errorMsg
      : "Sorry, your decertification failed. Please ensure you have no active orders or disputes. Contact our team if you have further questions.";
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF929EB8),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Icon
              isSuccess
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9FBEF),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/merchant_details/tick-circle.svg',
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE4E2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFEF3F2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/merchant_details/trash.svg',
                        width: 18,
                        height: 20,
                      ),
                    ),

              const SizedBox(height: 24),

              // Title
              Text(
                isSuccess
                    ? "Decertification Completed"
                    : "Decertification Failed",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151E2F),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF717F9A),
                ),
              ),

              // Customer care (only on failure)
              if (!isSuccess) ...[
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onCustomerCare,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.headphones_outlined,
                        color: Color(0xFF1D5DE5),
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      const Text(
                        "Customer Care",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D5DE5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
