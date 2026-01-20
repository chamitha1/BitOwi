import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderStatus status;

  const OrderDetailsPage({super.key, this.status = OrderStatus.pendingPayment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMainCard(),
            const SizedBox(height: 20),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF6F9FF),
      surfaceTintColor: const Color(0xFFF6F9FF),
      elevation: 0,
      titleSpacing: 0,
      // automaticallyImplyLeading: false,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/merchant_details/arrow_left.svg"),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Order Details',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF151E2F),
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        // Chat
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE8EFFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/orders/messages.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C3C),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: const Text(
                  '12',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Contact Button
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FF),
            border: Border.all(color: const Color(0xFF1D5DE5), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/orders/message-text.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1D5DE5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Contact',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D5DE5),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildStatusHeader(),
          const SizedBox(height: 24),
          _buildMainAmount(),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xffE8F0F7)),
          const SizedBox(height: 24),
          _buildDetailsList(),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    String iconPath;
    Color bgColor;
    String title;
    String? subtitle;

    switch (status) {
      case OrderStatus.pending:
        iconPath = 'assets/icons/orders/clock.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Pending Order';
        subtitle = null;
        break;
      case OrderStatus.pendingPayment:
        iconPath = 'assets/icons/orders/clock.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Payment Pending';
        subtitle =
            'Order will be held until 12:00:00 and will be cancelled after deadline';
        break;
      case OrderStatus.pendingReleased:
        iconPath = 'assets/icons/orders/lock.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Pending Released';
        subtitle = null;
        break;
      case OrderStatus.completed:
        iconPath = 'assets/icons/orders/clock.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Order Completed';
        subtitle = 'This Order has been Completed';
        break;
      case OrderStatus.cancelled:
        iconPath = 'assets/icons/orders/close-circle.svg';
        bgColor = const Color(0xFFFDF4F5);
        title = 'Payment Cancelled';
        subtitle = 'This order has been cancelled';
        break;
      case OrderStatus.arbitration:
        iconPath = 'assets/icons/orders/scale.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Arbitration';
        subtitle = 'This order is under arbitration';
        break;
      case OrderStatus.cryptoReleased:
        iconPath = 'assets/icons/orders/note-2.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Crypto Released';
        subtitle = null;
        break;
    }

    return Column(
      children: [
        // Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(iconPath, width: 32, height: 32),
          ),
        ),
        const SizedBox(height: 16),
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E2C37),
            fontFamily: 'Inter',
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          // Subtitle
          if (status == OrderStatus.pendingPayment)
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF425665),
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(text: 'Order will be held until '),
                  TextSpan(
                    text: '12:00:00',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                  TextSpan(text: ' and will be cancelled after deadline'),
                ],
              ),
            )
          else
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF425665),
                fontFamily: 'Inter',
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildMainAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151E2F),
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(text: '84,489.04 '),
              TextSpan(
                text: 'NGN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: "123456"));
            Get.snackbar(
              'Copied',
              'Amount copied to clipboard',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/deposit/copy.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xff2495E5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatColumn('Time', '03/26, 11.45', CrossAxisAlignment.start),
            _buildStatColumn(
              'Quantity(ETH)',
              '1.00000293',
              CrossAxisAlignment.center,
            ),
            _buildStatColumn(
              'Total(NGN)',
              '3,578,584.95',
              CrossAxisAlignment.end,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    CrossAxisAlignment alignment,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF717F9A),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF151E2F),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList() {
    return Column(
      children: [
        _buildDetailRow(
          'Seller',
          'Brandy Schimmel',
          hasAvatar: true,
          avatarPath: 'assets/icons/orders/Avatar.png',
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Order No', '19714381', hasCopy: true),
        const SizedBox(height: 12),
        _buildDetailRow('Order Time', '03/26, 10.30'),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Payment Methods',
          'Bank Cards',
          valueColor: const Color(0xFF1E2C37),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Bank',
          'China Everbright Bank',
          valueColor: const Color(0xFF1E2C37),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Bank Branches',
          'Macau',
          valueColor: const Color(0xFF1E2C37),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Bank Number', '7434 5784 3784 4983', hasCopy: true),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Buyer',
          'Janie Price DDS',
          hasAvatar: true,
          avatarPath: 'assets/icons/orders/Avatar1.png',
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Ads Messages', 'Selling USDT with quick'),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool hasAvatar = false,
    String? avatarPath,
    bool hasCopy = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FF).withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF717F9A),
              fontFamily: 'Inter',
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasAvatar && avatarPath != null) ...[
                ClipOval(
                  child: Image.asset(
                    avatarPath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? const Color(0xFF151E2F),
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              if (hasCopy) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      'Copied',
                      '$label copied to clipboard',
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/deposit/copy.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff2495E5),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.pendingPayment:
        // Cancel and Notify Payment
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D5DE5),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5DE5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Notify Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.pendingReleased:
        //outlined button
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Request for Arbitration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D5DE5),
              fontFamily: 'Inter',
            ),
          ),
        );

      case OrderStatus.cryptoReleased:
        // filled button
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D5DE5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Leave a Review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Inter',
            ),
          ),
        );

      case OrderStatus.completed:
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        );

      case OrderStatus.cancelled:
      case OrderStatus.arbitration:
        return const SizedBox.shrink();
    }
  }
}
