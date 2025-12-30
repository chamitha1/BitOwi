import 'package:BitOwi/features/merchant/presentation/widgets/reminder_card.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/step_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BecomeMerchantPage extends StatelessWidget {
  const BecomeMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Image.asset(
                        'assets/icons/withdrawal/back_arrow.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Merchant Details",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6A4EFF), Color(0xFF471AD9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/merchant_details/shield.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Become a Merchant",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Start accepting crypto payments and grow your business",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF454F63),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    const StepCard(
                      title: "KYC Verification",
                      description:
                          "Your identity helps us keep the platform secure",
                      iconPath: "assets/icons/merchant_details/id_card.svg",
                      stepNumber: "1",
                      iconBackgroundColor: Color(0xFFE9F6FF),
                    ),
                    const SizedBox(height: 16),
                    const StepCard(
                      title: "Deposit Fund",
                      description:
                          "Deposit minimum 1000 USDT to activate merchant account",
                      iconPath: "assets/icons/merchant_details/money.svg",
                      stepNumber: "2",
                      iconBackgroundColor: Color(0xFFF4E9FE),
                    ),

                    const SizedBox(height: 24),

                    const ReminderCard(),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Starting KYC Verification..."),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D5DE5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Start KYC Verification",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/merchant_details/arrow_right.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
