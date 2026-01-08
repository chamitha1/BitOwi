import 'package:BitOwi/features/wallet/presentation/controllers/deposit_controller.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/coin_selector_card.dart';
import 'transaction_history_page.dart';
import '../widgets/deposit_address_section.dart';
import '../widgets/friendly_reminder_card.dart';
import '../widgets/deposit_network_bottom_sheet.dart';

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
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Deposit Network",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2E3D5B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              barrierColor: Color(0xffECEFF5).withOpacity(0.7),
                              backgroundColor: Colors.transparent,
                              builder: (context) => DepositNetworkBottomSheet(
                                networks: controller.networkList,
                                selectedNetwork:
                                    controller.selectedNetwork.value,
                                onNetworkSelected: controller.onNetworkSelected,
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xffDAE0EE),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.selectedNetwork.value.isEmpty
                                        ? "Select Network"
                                        : controller.selectedNetwork.value,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff151E2F),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xff151E2F),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                              CustomSnackbar.showSuccess(
                                title: "Success",
                                message: "Address copied to clipboard",
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
