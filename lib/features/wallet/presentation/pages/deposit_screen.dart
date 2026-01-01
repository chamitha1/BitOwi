import 'package:BitOwi/features/wallet/presentation/controllers/deposit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/coin_selector_card.dart';
import 'transaction_history_page.dart';
import '../widgets/deposit_address_section.dart';
import '../widgets/friendly_reminder_card.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepositController());

    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xffF6F9FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/deposit/arrow_back.png",
                          width: 20,
                          height: 20,
                          color: const Color(0xff151E2F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Deposit",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff151E2F),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionHistoryPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/icons/deposit/clock.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => CoinSelectorCard(
                        coinList: controller.coinList,
                        selectedCoin: controller.selectedCoin.value,
                        onCoinSelected: controller.onCoinSelected,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DepositAddressSection(
                        address: controller.depositAddress.value,
                        screenshotController: controller.screenshotController,
                      );
                    }),
                    const SizedBox(height: 35),
                    const FriendlyReminderCard(),
                    const SizedBox(height: 35),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.saveQrCode(context);
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xff1D5DE5),
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1D5DE5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: controller.depositAddress.value,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Address copied to clipboard"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff1D5DE5),
                                    Color(0xff174AB7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Copy Address",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
