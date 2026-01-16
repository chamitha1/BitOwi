import 'package:BitOwi/features/wallet/presentation/controllers/balance_history_controller.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/features/wallet/presentation/pages/withdraw_screen.dart';
import 'package:BitOwi/features/wallet/presentation/pages/deposit_screen.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BalanceHistoryPage extends GetView<BalanceHistoryController> {
  const BalanceHistoryPage({super.key});

  String _shortRemark(String text, int max) {
    final t = text.trim();
    if (t.length <= max) return t;
    return '${t.substring(0, max)}...';
  }


  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BalanceHistoryController>()) {
      Get.put(BalanceHistoryController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(),
                    const SizedBox(height: 24),
                    const Text(
                      "Transaction History",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFilterTabs(),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.transactions.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.transactions.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No transactions found"),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.transactions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];
                          return _buildTransactionItem(tx);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.until(
              (route) => Get.currentRoute == '/HomeScreen' || route.isFirst,
            ),
            child: SvgPicture.asset(
              'assets/icons/withdrawal/arrow-left.svg',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Balance & History",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF151E2F),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.refreshData(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: SvgPicture.asset(
                'assets/icons/balance_history/refresh-circle.svg',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/balance_history/usdt.png',
                  width: 44,
                  height: 44,
                ),
                const SizedBox(width: 12),
                const Text(
                  "USDT",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF151E2F),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.totalBalance,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn("Valuation (USDT)", controller.valuationUsdt),
                _buildInfoColumn(
                  "Frozen",
                  controller.frozen,
                  crossAlign: CrossAxisAlignment.end,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    "Valuation (USDT)",
                    controller.valuationUsdt,
                  ),
                  _buildInfoColumn(
                    "Valuation (Local)",
                    controller.valuationOther,
                    crossAlign: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoColumn(
    String label,
    String value, {
    CrossAxisAlignment crossAlign = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF151E2F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF151E2F),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildTabButton(0, "All"),
        const SizedBox(width: 12),
        _buildTabButton(1, "Deposits"),
        const SizedBox(width: 12),
        _buildTabButton(2, "Withdrawals"),
      ],
    );
  }

  Widget _buildTabButton(int index, String text) {
    return Obx(() {
      final isSelected = controller.currentTab.value == index;
      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFECEFF5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF555555).withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF717F9A),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTransactionItem(Jour tx) {
    // Format amount sign
    double val =
        double.tryParse(tx.transAmount?.replaceAll(',', '') ?? '0') ?? 0.0;

    final isDeposit = tx.bizType == '1' || val > 0;

    final amountColor = isDeposit
        ? const Color(0xFF00C087)
        : const Color(0xFFFF4D4F);
    final iconBg = isDeposit
        ? const Color(0xFFEAF9F0)
        : const Color(0xFFFDECEB);
    final iconColor = isDeposit
        ? const Color(0xFF40A372)
        : const Color(0xFFE74C3C);
    final iconAsset = isDeposit
        ? 'assets/icons/home/deposit.svg'
        : 'assets/icons/home/withdraw.svg';

    final amountPrefix = isDeposit ? "+" : "-";
    if (val < 0) val = -val;
    final amountStr = "$amountPrefix${val.toStringAsFixed(2)}";

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.transactionDetail,
          parameters: {"id": tx.id ?? '', "type": tx.bizType ?? '1'},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(iconAsset, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDeposit ? "Deposit" : "Withdraw",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx.createDatetime != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                            tx.createDatetime is int
                                ? tx.createDatetime
                                : int.tryParse(tx.createDatetime.toString()) ??
                                      0,
                          ).toString().split('.')[0]
                        : '',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF717F9A),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountStr,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (tx.remark != null && tx.remark!.trim().isNotEmpty)
                Text(
                  _shortRemark(tx.remark!, 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF717F9A),
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  if (controller.symbol != null &&
                      controller.accountNumber != null) {
                    Get.to(
                      () => WithdrawScreen(
                        symbol: controller.symbol!,
                        accountNumber: controller.accountNumber!,
                      ),
                    );
                  } else {
                    CustomSnackbar.showError(
                      title: "Error",
                      message: "Account details missing",
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1D5DE5), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(0xffF6F9FF),
                ),
                child: const Text(
                  "Withdraw",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF1D5DE5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const DepositScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5DE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Deposit",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
