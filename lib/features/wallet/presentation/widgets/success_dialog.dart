import 'package:BitOwi/features/wallet/presentation/pages/balance_history_page.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SuccessDialog extends StatelessWidget {
  final String symbol;
  final String accountNumber;
  final Jour? newTransaction;

  const SuccessDialog({
    super.key,
    required this.symbol,
    required this.accountNumber,
    this.newTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Get.until(
                    (route) =>
                        Get.currentRoute == '/HomeScreen' || route.isFirst,
                  );
                },
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF9EA3AE),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SvgPicture.asset(
              'assets/icons/withdrawal/success.svg',
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 24),
            const Text(
              "Withdrawal Submitted Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your withdrawal request has been submitted and is being processed. You can track the status in Transaction History.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF454F63),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.to(
                    () => const BalanceHistoryPage(),
                    arguments: {
                      'symbol': symbol,
                      'accountNumber': accountNumber,
                      'newTransaction': newTransaction,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5DE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Transaction History",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
