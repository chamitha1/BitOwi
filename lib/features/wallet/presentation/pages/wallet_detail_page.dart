import 'package:BitOwi/features/wallet/presentation/controllers/wallet_detail_controller.dart';
import 'package:BitOwi/features/wallet/presentation/pages/transaction_detail_page.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/transaction_card.dart';
import 'package:BitOwi/models/account_detail_account_and_jour_res.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:intl/intl.dart';

class WalletDetailPage extends GetView<WalletDetailController> {
  const WalletDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WalletDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          "Balances",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: const Color(0xFF151E2F),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.accountInfo.value == null &&
            controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Color(0xff1D5DE5)),
            ),
          );
        }

        if (controller.accountInfo.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No data available"),
                ElevatedButton(
                  onPressed: controller.refreshData,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final info = controller.accountInfo.value!;

        return Column(
          children: [
            Expanded(
              child: EasyRefresh(
                onRefresh: controller.refreshData,
                onLoad: controller.loadMore,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _buildTopBox(info),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 24.w, 20.w, 12.w),
                        child: Text(
                          "Transaction History",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: const Color(0xFF151E2F),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.w),
                        child: _buildFilterTabs(),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index < controller.transactionList.length) {
                            final item = controller.transactionList[index];
                            return _buildTransactionItem(item);
                          }
                          return null;
                        }, childCount: controller.transactionList.length),
                      ),
                    ),
                    if (controller.transactionList.isEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              "No transactions found",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: 20.w)),
                  ],
                ),
              ),
            ),
            _buildBottomBar(info),
          ],
        );
      }),
    );
  }

  Widget _buildTopBox(AccountDetailAccountAndJourRes info) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30.w),
          padding: EdgeInsets.fromLTRB(20.w, 40.w, 20.w, 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                info.currency ?? '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: const Color(0xFF151E2F),
                ),
              ),
              SizedBox(height: 20.w),
              _buildRow(
                "Total Amount",
                double.tryParse(info.totalAmount ?? '0')?.toStringAsFixed(2) ??
                    '0.00',
              ),
              _buildRow(
                "Available",
                double.tryParse(info.usableAmount ?? '0')?.toStringAsFixed(2) ??
                    '0.00',
              ),
              _buildRow(
                "Frozen",
                double.tryParse(info.frozenAmount ?? '0')?.toStringAsFixed(2) ??
                    '0.00',
              ),
              Divider(height: 24.w, color: const Color(0xFFF3F4F6)),
              _buildRow(
                "Valuation (USDT)",
                " ${double.tryParse(info.totalAmountUsdt ?? '0')?.toStringAsFixed(2) ?? '0.00'}",
              ),
              _buildRow(
                "Valuation (USD)",
                " ${double.tryParse(info.totalAsset ?? '0')?.toStringAsFixed(2) ?? '0.00'}",
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: info.icon != null && info.icon!.isNotEmpty
                    ? Image.network(
                        info.icon!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.currency_bitcoin),
                      )
                    : const Icon(Icons.currency_bitcoin),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: const Color(0xFF717F9A),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: const Color(0xFF151E2F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AccountDetailAccountAndJourRes info) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48.w,
                child: ElevatedButton(
                  onPressed: () {
                    // Deposit
                    Get.toNamed(
                      Routes.deposit,
                      parameters: {'symbol': info.currency ?? ''},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Deposit",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 48.w,
                child: OutlinedButton(
                  onPressed: () {
                    // Withdraw
                    Get.toNamed(
                      Routes.withdrawal,
                      parameters: {
                        'symbol': info.currency ?? '',
                        'accountNumber': controller.accountNumber,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1D5DE5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Withdraw",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: const Color(0xFF1D5DE5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          _buildTabButton(0, "All"),
          SizedBox(width: 12.w),
          _buildTabButton(1, "Deposits"),
          SizedBox(width: 12.w),
          _buildTabButton(2, "Withdrawals"),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    return Obx(() {
      final isSelected = controller.currentTab.value == index;
      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
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
              fontSize: 14.sp,
              color: isSelected ? Colors.white : const Color(0xFF717F9A),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTransactionItem(Jour tx) {
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
          parameters: {"id": tx.id ?? "", "type": tx.bizType ?? "1"},
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 12.w), //  for list spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(iconAsset, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDeposit ? "Deposit" : "Withdraw",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color(0xFF151E2F),
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    tx.createDatetime != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              tx.createDatetime is int
                                  ? tx.createDatetime
                                  : int.tryParse(
                                          tx.createDatetime.toString(),
                                        ) ??
                                        0,
                            ),
                          )
                        : '-',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xFF717F9A),
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
                    fontSize: 14.sp,
                    color: amountColor,
                  ),
                ),
                if (tx.remark != null && tx.remark!.trim().isNotEmpty) ...[
                  SizedBox(height: 4.w),
                  Text(
                    tx.remark!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xFF717F9A),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
