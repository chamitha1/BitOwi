import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';
import 'package:BitOwi/features/orders/presentation/controllers/orders_controller.dart';
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

              // order cards
              Expanded(
                child: Obx(() {
                  List<Widget> orders = [];

                  if (controller.currentTabIndex.value == 0) {
                    orders = [
                      const OrderCard(
                        orderNo: "19714381",
                        status: OrderStatus.pending,
                        title: "Sell ETH",
                        date: "03/26, 10.30",
                        quantity: "1.00000845",
                        total: "3,578,584.95",
                        userName: "Brandy Schimmel",
                        userAvatar: "assets/icons/orders/Avatar.png",
                        isCertified: true,
                        hasUnreadMessages: true,
                      ),
                      const OrderCard(
                        orderNo: "19714382",
                        status: OrderStatus.pendingPayment,
                        title: "Sell ETH",
                        date: "03/26, 11.15",
                        quantity: "0.005",
                        total: "2,000,000.00",
                        userName: "John Doe",
                        userAvatar: "assets/icons/orders/Avatar1.png",
                        isCertified: false,
                        hasUnreadMessages: false,
                      ),
                      const OrderCard(
                        orderNo: "19714385",
                        status: OrderStatus.arbitration,
                        title: "Sell ETH",
                        date: "03/25, 14.20",
                        quantity: "500.00",
                        total: "750,000.00",
                        userName: "Alex Smith",
                        userAvatar: "assets/icons/orders/Avatar1.png",
                        isCertified: true,
                        hasUnreadMessages: true,
                      ),
                    ];
                  } else if (controller.currentTabIndex.value == 1) {
                    // Completed
                    orders = [
                      const OrderCard(
                        orderNo: "19714383",
                        status: OrderStatus.completed,
                        title: "Sell ETH",
                        date: "03/25, 09.30",
                        quantity: "0.5",
                        total: "1,789,292.47",
                        userName: "Jane Tech",
                        userAvatar: "assets/icons/orders/Avatar.png",
                        isCertified: true,
                        hasUnreadMessages: false,
                      ),
                    ];
                  } else {
                    // Cancelled
                    orders = [
                      const OrderCard(
                        orderNo: "19714384",
                        status: OrderStatus.cancelled,
                        title: "Sell ETH",
                        date: "03/24, 18.00",
                        quantity: "10.0",
                        total: "150,000.00",
                        userName: "Crypto King",
                        userAvatar: "assets/icons/orders/Avatar1.png",
                        isCertified: false,
                        hasUnreadMessages: false,
                      ),
                    ];
                  }

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    children: orders,
                  );
                }),
              ),
            ],
          ),
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
