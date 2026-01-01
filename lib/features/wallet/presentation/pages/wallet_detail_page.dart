import 'package:BitOwi/features/wallet/presentation/controllers/wallet_detail_controller.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/transaction_card.dart';
import 'package:BitOwi/models/account_detail_account_and_jour_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
          ),
        ),
        title: Text(
          "Assets",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: const Color(0xFF151E2F),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.accountInfo.value == null && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
        }
        
        if(controller.accountInfo.value == null) {
             return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text("No data available"),
                        ElevatedButton(onPressed: controller.refreshData, child: const Text("Retry"))
                    ]
                )
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
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                             if(index < controller.transactionList.length){
                                final item = controller.transactionList[index];
                                final isDeposit = item.bizCategory?.toLowerCase() == 'deposit' || item.bizCategory?.toLowerCase() == 'charge'; // Adjust logic
                                
                                return TransactionCard(
                                  isDeposit: isDeposit,
                                  amount: "${isDeposit ? '+' : ''}${item.transAmount} ${item.currency}", 
                                  status: item.status ?? 'Unknown', 
                                  address: item.accountNumber ?? '-', 
                                  date: item.createDatetime != null 
                                      ? DateFormat('yyyy-MM-dd HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            item.createDatetime is int 
                                              ? item.createDatetime 
                                              : int.tryParse(item.createDatetime.toString()) ?? 0
                                          )
                                        ) 
                                      : '-',
                                );
                             }
                             return null;
                          },
                          childCount: controller.transactionList.length,
                        ),
                      ),
                    ),
                    if (controller.transactionList.isEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              "No transactions found",
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
              _buildRow("Total Amount", info.totalAmount ?? '0'),
              _buildRow("Available", info.usableAmount ?? '0'),
              _buildRow("Frozen", info.frozenAmount ?? '0'),
              Divider(height: 24.w, color: const Color(0xFFF3F4F6)),
              _buildRow("Valuation (USDT)", "~${info.totalAmountUsdt ?? '0'}"),
             // _buildRow("Valuation (${info.totalAssetCurrency})", "~${info.totalAsset ?? '0'}"),
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
                    ? Image.network(info.icon!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.currency_bitcoin)) 
                    : const Icon(Icons.currency_bitcoin)
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
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
                height: 48.w,
                child: ElevatedButton(
                  onPressed: () {
                     // Deposit
                     Get.toNamed(Routes.deposit, parameters: {'symbol': info.currency ?? ''});
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
                     Get.toNamed(Routes.withdrawal, parameters: {
                         'symbol': info.currency ?? '',
                         'accountNumber': controller.accountNumber,
                     });
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
    );
  }
}
