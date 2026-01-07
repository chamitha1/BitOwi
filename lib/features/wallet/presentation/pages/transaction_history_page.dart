import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/features/wallet/presentation/controllers/transaction_history_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TransactionHistoryController controller = Get.put(
    TransactionHistoryController(),
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                        // color: Color(0xffECEFF5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/withdrawal/arrow-left.svg",
                          width: 20,
                          height: 20,
                          color: const Color(0xff151E2F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "History",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff151E2F),
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    "assets/icons/home/headphones.svg",
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
            ),

            // Tabs
            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffF6F9FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffECEFF5), width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.isDeposit.value
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: controller.isDeposit.value
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              "Deposit",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: controller.isDeposit.value
                                    ? const Color(0xff151E2F)
                                    : const Color(0xff929EB8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !controller.isDeposit.value
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !controller.isDeposit.value
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              "Withdraw",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !controller.isDeposit.value
                                    ? const Color(0xff151E2F)
                                    : const Color(0xff929EB8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    (controller.isDeposit.value
                        ? controller.depositList.isEmpty
                        : controller.withdrawList.isEmpty)) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = controller.isDeposit.value
                    ? controller.depositList
                    : controller.withdrawList;

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "No transactions yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  itemCount: list.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final item = list[index];

                    if (controller.isDeposit.value) {
                      return _buildDepositItem(item);
                    } else {
                      return _buildWithdrawItem(item);
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.transactionDetail,
          parameters: {
            'id': item.id,
            'type': '1', // Default type 1 for deposits/jour
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffF1F4F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.transAmount != null
                      ? "+${item.transAmount} ${item.currency ?? ''}"
                      : "+0 ${item.currency ?? ''}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff27AE60),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F5E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Completed",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xff27AE60),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.remark ?? "Deposit",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff929EB8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item.createDatetime != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                          item.createDatetime is int
                              ? item.createDatetime
                              : int.tryParse(item.createDatetime.toString()) ??
                                    0,
                        ).toString().split('.')[0]
                      : "",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff929EB8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawItem(dynamic item) {
    final status = controller.statusEnum[item.status] ?? item.status;

    Color statusColor = const Color(0xff151E2F);
    Color statusBg = const Color(0xffF6F9FF);

    if (item.status == '2' || item.status == '5') {
      statusColor = const Color(0xffFF5252);
      statusBg = const Color(0xffFFEBEE);
    } else if (item.status == '6') {
      // Completed
      statusColor = const Color(0xff27AE60);
      statusBg = const Color(0xffE8F5E9);
    } else {
      // Processing
      statusColor = const Color.fromARGB(255, 235, 161, 2);
      statusBg = const Color(0xffFFF3E0);
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.transactionDetail,
          parameters: {
            'id': item.id,
            'type': '2', // Explicitly type 2 for withdrawals
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffF1F4F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "-${item.actualAmount} ${item.currency}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEB5757),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "To: ${item.payCardNo ?? 'Unknown'}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff929EB8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item.createDatetime != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                          item.createDatetime is int
                              ? item.createDatetime
                              : int.tryParse(item.createDatetime.toString()) ??
                                    0,
                        ).toString().split('.')[0]
                      : "",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff929EB8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
