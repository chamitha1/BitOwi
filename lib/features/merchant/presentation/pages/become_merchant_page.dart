import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/become_merchant_controller.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/decertification_result_dialog.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/decertify_confirmation_bottom_sheet.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/reminder_card.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/step_card.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/verified_merchant_bottom_sheet.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BecomeMerchantPage extends StatelessWidget {
  BecomeMerchantPage({super.key});

  final BecomeMerchantController controller =
      Get.find<BecomeMerchantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: CommonAppBar(title: "Merchant Details", onBack: () => Get.back()),

      body: SafeArea(
        top: false,
        child: EasyRefresh(
          controller: controller.refreshController,
          onRefresh: () async {
            await controller.refreshPage(); // 🔁 moved to controller
            controller.refreshController.finishRefresh();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: SoftCircularLoader()),
              );
            }

            // final assetInfo = controller.assetInfo.value;
            final latestInfo = controller.latestSubmittedInfo.value;

            // 🧠 Keep existing side-effect (bottom sheet)

            if (controller.merchantStatus == '1' &&
                !controller.hasShownMerchantSheet) {
              controller.hasShownMerchantSheet = true; // ✅ guard immediately
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showVerifiedMerchantBottomSheet(context);
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // 🟢 ICON
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF52B7FF), Color(0xFF1D5DE5)],
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

                  const SizedBox(height: 10),

                  const Text(
                    "Become a Merchant",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFF151E2F),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Start accepting crypto payments and grow your business",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF717F9A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🧾 STEP 1
                  StepCard(
                    title: "KYC Verification",
                    description:
                        "Your identity helps us keep the platform secure",
                    iconPath: "assets/icons/merchant_details/id_card.svg",
                    stepNumber: "1",
                    iconBackgroundColor: const Color(0xFFE9F6FF),
                    secondaryIconPath: latestInfo?.status == '2'
                        ? "assets/icons/merchant_details/close-square.svg"
                        : latestInfo?.status == '1'
                        ? "assets/icons/merchant_details/tick-circle.svg"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // 💰 STEP 2
                  StepCard(
                    title: "Deposit Fund",
                    description:
                        "Deposit amount ${controller.frozenAmount} USDT",
                    iconPath: "assets/icons/merchant_details/money.svg",
                    stepNumber: "2",
                    iconBackgroundColor: const Color(0xFFF4E9FE),
                    secondaryIconPath: controller.hasEnoughAmount
                        ? "assets/icons/merchant_details/tick-circle.svg"
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // 🔔 REMINDER
                  ReminderCard(
                    merchantStatus: controller.merchantStatus,
                    identifyOrderLatestSubmittedInfoStatus:
                        latestInfo?.status ?? '',
                  ),

                  const SizedBox(height: 30),

                  // 🔘 ACTION BUTTON (UNCHANGED LOGIC)
                  _buildActionButton(
                    context,
                    controller.merchantStatus,
                    latestInfo?.status ?? '',
                    controller.applyMerchant, // 🧠 moved
                    onReturn: () async {
                      await controller.refreshPage(); // 🔁 moved
                    },
                  ),

                  const SizedBox(height: 54),

                  // ❌ DECERTIFY
                  if (controller.merchantStatus == '1')
                    TextButton(
                      onPressed: () {
                        showDecertifyConfirmationBottomSheet(
                          context,
                          onProceed: () async {
                            controller.isLoading.value = true;

                            final res = await controller.removeMerchant(); // 🧠

                            controller.isLoading.value = false;

                            final errorCode = res['errorCode'] ?? '';

                            showDecertificationResultDialog(
                              context,
                              result: errorCode == 'Success'
                                  ? DecertificationResult.success
                                  : DecertificationResult.failed,
                            );

                            await controller.refreshPage();
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/merchant_details/profile_delete.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          AppText.p2Medium(
                            "Request to Decertification",
                            color: Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Container buildBecomeMerchantIcon() {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF52B7FF), Color(0xFF1D5DE5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/merchant_details/shield.svg',
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}

Widget _buildActionButton(
  BuildContext context,
  String merchantStatus,
  String identifyOrderLatestSubmittedInfoStatus,
  Future<void> Function() onMerchantApply, {
  required Future<void> Function() onReturn,
}) {
  final config = _getActionConfig(
    context,
    merchantStatus,
    identifyOrderLatestSubmittedInfoStatus,
    onMerchantApply,
    onReturn,
  );

  if (config == null) {
    return const SizedBox.shrink();
  }

  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: config.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        elevation: 0,
        disabledBackgroundColor: const Color(0xFFCBD5E1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            config.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: config.textColor,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/merchant_details/arrow_right.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(config.textColor, BlendMode.srcIn),
          ),
        ],
      ),
    ),
  );
}

_ActionButtonConfig? _getActionConfig(
  BuildContext context,
  String merchantStatus,
  String identifyOrderLatestSubmittedInfoStatus,
  Future<void> Function() onMerchantApply,
  Future<void> Function() onReturn,
) {
  // merchant KYC stil not applied
  if ((merchantStatus == '-1')) {
    if (identifyOrderLatestSubmittedInfoStatus == '') {
      return _ActionButtonConfig(
        label: "Start KYC Verification",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () async {
          final result = await Get.toNamed(
            Routes.kycPersonalInformation,
            arguments: {'merchantStatus': merchantStatus, 'isEdit': false},
          );

          final bool shouldRefresh = result == true;

          if (shouldRefresh == true) {
            await onReturn();
          }
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '0') {
      return _ActionButtonConfig(
        label: "Start KYC Verification",
        backgroundColor: const Color(0xFFB9C6E2),
        textColor: const Color(0xFF717F9A),
        onPressed: () {
          // null;
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '2') {
      return _ActionButtonConfig(
        label: "Retry KYC Verification",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () async {
          final result = await Get.toNamed(
            Routes.kycPersonalInformation,
            arguments: {'merchantStatus': merchantStatus, 'isEdit': true},
          );

          final bool shouldRefresh = result == true;

          if (shouldRefresh == true) {
            await onReturn();
          }
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '1') {
      return _ActionButtonConfig(
        label: "Apply for Merchant KYC",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () {
          onMerchantApply();
        },
      );
    }
  } else {
    switch (merchantStatus) {
      case '0':
        return null;
      // return _ActionButtonConfig(
      //   label: "Deposit Fund",
      //   backgroundColor: const Color(0xFFCBD5E1),
      //   textColor: const Color(0xFF64748B),
      //   onPressed: null,
      // );

      case '3':
        return _ActionButtonConfig(
          label: "Start KYC Verification",
          backgroundColor: const Color(0xFFCBD5E1),
          textColor: const Color(0xFF64748B),
          onPressed: null,
        );

      case '2':
        return _ActionButtonConfig(
          label: "Retry KYC Verification",
          backgroundColor: const Color(0xFF1D5DE5),
          textColor: Colors.white,
          onPressed: () {
            onMerchantApply();
          },
        );

      case '4':
        return _ActionButtonConfig(
          label: "Apply for Merchant KYC",
          backgroundColor: const Color(0xFF1D5DE5),
          textColor: Colors.white,
          onPressed: () {
            onMerchantApply();
          },
        );

      case '1':
        return null;
      // return _ActionButtonConfig(
      //   label: "Deposit Fund",
      //   backgroundColor: const Color(0xFF1D5DE5),
      //   textColor: Colors.white,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const DepositScreen()),
      //     );
      //   },
      // );
    }
  }
  return _ActionButtonConfig(
    label: "-",
    backgroundColor: const Color(0xFF1D5DE5),
    textColor: Colors.white,
    onPressed: () {},
  );
}

class _ActionButtonConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  _ActionButtonConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });
}
