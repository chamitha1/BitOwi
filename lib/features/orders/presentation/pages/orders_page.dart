import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';
import 'package:BitOwi/features/orders/presentation/controllers/orders_controller.dart';
import 'package:BitOwi/features/orders/presentation/pages/order_details_page.dart';
import 'package:BitOwi/features/orders/utils/order_helper.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrdersController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                "Orders",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF151E2F),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),

              //Tabs
              Container(
                width: double.infinity,
                child: Obx(() {
                  return Row(
                    children: [
                      _buildTabItem("Processing", 0),
                      const SizedBox(width: 8),
                      _buildTabItem("Completed", 1),
                      const SizedBox(width: 8),
                      _buildTabItem("Cancelled", 2),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Order Cards
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.ordersList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.ordersList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No records',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF717F9A),
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }

                  return EasyRefresh(
                    onRefresh: () async {
                      await controller.refresh();
                    },
                    onLoad: controller.isEnd.value
                        ? null
                        : () async {
                            await controller.loadMore();
                          },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.ordersList.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(controller.ordersList[index]);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(TradeOrderItem orderItem) {
    // is user buyer or seller
    final isBuyer = orderItem.buyUser != null;

    return OrderCard(
      orderNo: orderItem.id ?? '',
      status: OrderHelper.mapApiStatusToOrderStatus(orderItem.status),
      title: '${isBuyer ? 'Buy' : 'Sell'} ${orderItem.tradeCoin ?? ''}',
      date: OrderHelper.formatDateTime(orderItem.createDatetime),
      quantity: orderItem.count ?? '0',
      total: orderItem.tradeAmount ?? '0',
      userName: isBuyer
          ? (orderItem.sellerNickname ?? 'Unknown')
          : (orderItem.buyerNickname ?? 'Unknown'),
      userAvatar: isBuyer
          ? (orderItem.sellerPhoto ?? '')
          : (orderItem.buyerPhoto ?? ''),
      isCertified: false, 
      hasUnreadMessages: false, 
      onTap: () => Get.to(
        () => OrderDetailsPage(
          status: OrderHelper.mapApiStatusToOrderStatus(orderItem.status),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = controller.currentTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFECEFF5),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF717F9A),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
