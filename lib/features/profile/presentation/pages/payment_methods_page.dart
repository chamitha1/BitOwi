import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_empty_state.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/confirm_dialog.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/models/bankcard_list_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  List<BankcardListRes> list = [];
  late EasyRefreshController _controller;
  // late StreamSubscription<BankcardEditEvent> beStream;
  // bool canChose = false;
  bool isEnd = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(controlFinishRefresh: true);
    // beStream = EventBusUtil.listenBankcardEdit((event) {
    getBankCardList();
    // });
    // canChose = Get.parameters['chose'] == '1';
  }

  @override
  void dispose() {
    _controller.dispose();
    // beStream.cancel();
    super.dispose();
  }

  Future<void> getBankCardList() async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
      });
      final resList = await AccountApi.getBankCardList();
      if (!mounted) return;
      setState(() {
        list = resList;
        isEnd = true;
      });
    } catch (e) {
      print("getBankCardList getList error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    _controller.finishRefresh();
  }

  bool get isEmpty {
    return isEnd && list.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Payment Methods", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Payment methods list
              Expanded(
                child: EasyRefresh(
                  controller: _controller,
                  onRefresh: getBankCardList,
                  // refreshOnStart: true,
                  // onLoad: onLoad,
                  child: isLoading
                      ? const SoftCircularLoader()
                      : isEmpty
                      ? CommonEmptyState(title: 'No Payment Methods Added')
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 20),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return buildPaymentMethodCard(list[index], index);
                          },
                        ),
                ),
              ),
              // Add Payment Method button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, top: 20),
                child: buildAddPaymentButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(BankcardListRes item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: 7,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFFFAD4F),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Bank logo
          if (item.pic != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.pic == null
                  ? Image.asset(
                      'assets/icons/profile_page/bankcard.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.fill,
                    )
                  : CommonImage(
                      item.pic ?? '',
                      fit: BoxFit.cover,
                      width: 56,
                      height: 56,
                    ),
            ),
            const SizedBox(width: 14),
          ],
          // Bank details
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // name
                    Flexible(
                      child: Text(
                        item.bankName ?? '--',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF151E2F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // currency
                    if (item.currency != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF9F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText.p4Medium(
                          item.currency ?? '',
                          color: Color(0xFF40A372),
                        ),
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 6),

                // card/mobile number
                AppText.p3Medium(
                  item.bankcardNumber ?? item.bindMobile ?? '',
                  color: Color(0xFF717F9A),
                ),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
              _actionIcon(
                asset: 'assets/icons/profile_page/trash_bin.svg',
                bgColor: const Color(0xFFFFF1F1),
                iconColor: const Color(0xFFFF5A5A),
                onTap: () async {
                  onDeletePaymentMethod(item);
                },
              ),
              const SizedBox(width: 8),
              _actionIcon(
                asset: 'assets/icons/profile_page/edit_pencil.svg',
                bgColor: const Color(0xFFF1F4FA),
                iconColor: const Color(0xFF64748B),
                onTap: () async {
                  await onEditPaymentMethod(item);
                },
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onEditPaymentMethod(BankcardListRes item) async {
    if (item.type == '0' && item.bankcardNumber?.isNotEmpty == true) {
      final refreshed = await Get.toNamed(
        Routes.addBankCardPage,
        parameters: {"id": item.id},
      );
      if (refreshed == true) {
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "Bank card updated successfully",
        );
        getBankCardList();
      }
    } else {
      final refreshed = await Get.toNamed(
        Routes.addMobileMoneyPage,
        parameters: {"id": item.id},
      );
      if (refreshed == true) {
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "Mobile money updated successfully",
        );
        getBankCardList();
      }
    }
  }

  void onDeletePaymentMethod(BankcardListRes item) {
    showCommonConfirmDialog(
      context,
      title: "Confirmation to Delete",
      message: "Are you sure you want to delete this payment method?",
      primaryText: "Confirm",
      secondaryText: "Cancel",
      onPrimary: () async {
        if (isLoading) return;

        setState(() {
          isLoading = true;
        });

        try {
          await AccountApi.deleteBankCard(item.id);

          setState(() {
            list.removeWhere((e) => e.id == item.id);
          });

          CustomSnackbar.showSuccess(
            title: "Success",
            message: "Payment method deleted successfully",
          );
        } catch (e) {
          debugPrint("Payment method deleted error: $e");

          CustomSnackbar.showError(
            title: "Error",
            message: "Something went wrong",
          );
        } finally {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
      onSecondary: () {
        debugPrint("User cancelled payment method delete");
      },
    );
  }

  Widget _actionIcon({
    required String asset,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget buildAddPaymentButton() {
    return PrimaryButton(
      text: "Add Payment Method",
      enabled: true,
      onPressed: () async {
        final result = await showPaymentMethodBottomSheet();
        if (result == 0) {
          // Bank Card flow
          final refreshed = await Get.toNamed(Routes.addBankCardPage);
          if (refreshed == true) {
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Bank card added successfully",
            );
            getBankCardList();
          }
        } else if (result == 1) {
          // Mobile Money flow
          final refreshed = await Get.toNamed(Routes.addMobileMoneyPage);
          if (refreshed == true) {
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Mobile money updated successfully",
            );
            getBankCardList();
          }
        }
      },
    );
  }
}

Future<int?> showPaymentMethodBottomSheet() async {
  int? tempSelectedIndex;

  return showModalBottomSheet<int>(
    context: Get.context!,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9C6E2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Payment Method",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _paymentOption(
                        title: "Bank Card",
                        icon: "assets/icons/profile_page/bank_card.svg",
                        iconBgColor: const Color(0xFFFFFBF6),
                        index: 0,
                        selectedIndex: tempSelectedIndex,
                        onTap: () {
                          setModalState(() => tempSelectedIndex = 0);
                        },
                      ),
                      const SizedBox(height: 12),
                      _paymentOption(
                        title: "Mobile Money",
                        icon: "assets/icons/profile_page/mobile_money.svg",
                        iconBgColor: const Color(0xFFFDF4F5),
                        index: 1,
                        selectedIndex: tempSelectedIndex,
                        onTap: () {
                          setModalState(() => tempSelectedIndex = 1);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Proceed button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    text: "Proceed",
                    enabled: tempSelectedIndex != null,
                    onPressed: () {
                      Navigator.pop(context, tempSelectedIndex);
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _paymentOption({
  required String title,
  required String icon,
  required Color iconBgColor,
  required int index,
  required int? selectedIndex,
  required VoidCallback onTap,
}) {
  final bool isSelected = selectedIndex == index;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF1D5DE5) : const Color(0xFFECEFF5),
          width: 1.2,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: SvgPicture.asset(icon, width: 24, height: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(child: AppText.p2Medium(title, color: Color(0xFF151E2F))),
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_off_outlined,
            color: isSelected
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFDAE0EE),
          ),
        ],
      ),
    ),
  );
}
