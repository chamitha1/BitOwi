import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/features/p2p/presentation/widgets/download_app_bottom_sheet.dart';
import 'package:BitOwi/features/profile/presentation/pages/chat.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/im_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';
import 'package:BitOwi/features/orders/presentation/widgets/action_confirmation_bottom_sheet.dart';
import 'package:BitOwi/features/orders/presentation/widgets/notify_payment_dialog.dart';
import 'package:BitOwi/features/orders/presentation/widgets/confirm_release_dialog.dart';
import 'package:BitOwi/features/orders/presentation/widgets/rate_experience_bottom_sheet.dart';

import 'package:BitOwi/features/orders/utils/order_helper.dart';
import 'package:BitOwi/models/trade_order_detail_res.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  TradeOrderDetailRes? orderDetail;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    try {
      AppLogger.d('🔄 Fetching order detail for ID: ${widget.orderId}');
      setState(() {
        isLoading = true;
        error = null;
      });

      final detail = await P2PApi.getTradeOrderDetail(widget.orderId);
      AppLogger.d(
        '✅ Order detail fetched: ${detail.id}, Amount: ${detail.tradeAmount}, Currency: ${detail.tradeCurrency}',
      );
      AppLogger.d('📅 invalidDatetime: ${detail.invalidDatetime}');

      setState(() {
        orderDetail = detail;
        isLoading = false;
      });
      AppLogger.d('✅ State updated, UI should rebuild now');
    } catch (e) {
      AppLogger.d('❌ Error fetching order detail: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  bool get isSeller {
    if (orderDetail == null) return false;
    final userId = Get.find<UserController>().user.value?.id.toString();
    return userId == orderDetail!.sellUser;
  }

  OrderStatus get status {
    if (orderDetail == null) return OrderStatus.pending;
    return OrderHelper.mapApiStatusToOrderStatus(orderDetail!.status);
  }

  // ==================== ACTION HANDLERS ====================

  void _showCancelOrderBottomSheet() {
    Get.bottomSheet(
      ActionConfirmationBottomSheet(actionType: ActionType.cancelOrder),
      isScrollControlled: true,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleCancelOrder();
      }
    });
  }

  Future<void> _handleCancelOrder() async {
    try {
      AppLogger.d('🔄 Cancelling order: ${widget.orderId}');
      _showLoadingDialog();

      await P2PApi.cancelOrder(widget.orderId);

      _hideLoadingDialog();
      _showSuccessSnackbar('Order cancelled successfully');

      await _fetchOrderDetail();
    } catch (e) {
      AppLogger.d('❌ Error cancelling order: $e');
      _hideLoadingDialog();
      _showErrorSnackbar(e.toString());
    }
  }

  void _showNotifyPaymentDialog() {
    Get.dialog(
      NotifyPaymentDialog(
        onConfirm: () {
          Get.back(); // Close dialog
          _handleNotifyPayment();
        },
      ),
    );
  }

  ///Mark as Paid API Call
  Future<void> _handleNotifyPayment() async {
    try {
      AppLogger.d('🔄 Marking order as paid: ${widget.orderId}');
      _showLoadingDialog();

      await P2PApi.markOrderPay(widget.orderId);

      _hideLoadingDialog();
      _showSuccessSnackbar('Payment notification sent');

      await _fetchOrderDetail();
    } catch (e) {
      AppLogger.d('❌ Error notifying payment: $e');
      _hideLoadingDialog();
      _showErrorSnackbar(e.toString());
    }
  }

  void _showArbitrationBottomSheet() {
    Get.bottomSheet(
      ActionConfirmationBottomSheet(actionType: ActionType.arbitration),
      isScrollControlled: true,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleArbitrationRequest();
      }
    });
  }

  ///Arbitration API Call
  Future<void> _handleArbitrationRequest() async {
    try {
      AppLogger.d('🔄 Requesting arbitration for order: ${widget.orderId}');
      _showLoadingDialog();

      await P2PApi.applyArbitration(widget.orderId);

      _hideLoadingDialog();
      _showSuccessSnackbar('Arbitration request submitted');

      await _fetchOrderDetail();
    } catch (e) {
      AppLogger.d('❌ Error requesting arbitration: $e');
      _hideLoadingDialog();
      _showErrorSnackbar(e.toString());
    }
  }

  void _showRateExperienceBottomSheet() {
    RateExperienceBottomSheet.show(
      context,
      orderId: widget.orderId,
      onSuccess: () {
        _fetchOrderDetail(); // Refresh to update review status if needed
      },
    );
  }

  // ==================== HELPER METHODS ====================

  void _showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF1D5DE5))),
      barrierDismissible: false,
    );
  }

  void _hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void _showSuccessSnackbar(String message) {
    CustomSnackbar.showSuccess(title: 'Success', message: message);
  }

  void _showErrorSnackbar(String message) {
    CustomSnackbar.showError(title: 'Error', message: message);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || orderDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${error ?? "Failed to load order"}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchOrderDetail,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
        // Stack(
        //   clipBehavior: Clip.none,
        //   children: [
        //     Container(
        //       width: 40,
        //       height: 40,
        //       decoration: const BoxDecoration(
        //         color: Color(0xFFE8EFFF),
        //         shape: BoxShape.circle,
        //       ),
        //       child: Center(
        //         child: SvgPicture.asset(
        //           'assets/icons/orders/messages.svg',
        //           width: 20,
        //           height: 20,
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //       right: -6,
        //       top: -6,
        //       child: Container(
        //         padding: const EdgeInsets.all(2),
        //         decoration: const BoxDecoration(
        //           color: Color(0xFFE74C3C),
        //           shape: BoxShape.circle,
        //         ),
        //         constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        //         child: const Text(
        //           '12',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 10,
        //             fontWeight: FontWeight.w500,
        //             fontFamily: 'Inter',
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(width: 16),
        // Contact Button
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            if (PlatformUtils().isMobile) {
              // 🔹 Build group conversation ID
              final String groupId = 'group_${widget.orderId}';

              // 🔹 Fetch conversation from IM SDK
              final res = await IMUtil.sdkInstance
                  .getConversationManager()
                  .getConversation(conversationID: groupId);

              if (res.code == 0) {
                final conversation = res.data;
                if (conversation != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Chat(selectedConversation: conversation),
                    ),
                  );
                }
              }
            } else {
              // DownloadModal.showModal(context);
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const DownloadAppBottomSheet(),
              );
            }
          },
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F9FF),
              border: Border.all(color: const Color(0xFF1D5DE5), width: 1.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/chat/messages.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1D5DE5),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                AppText.p3Medium('Contact', color: Color(0xFF1D5DE5)),
              ],
            ),
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

    AppLogger.d(
      '🔍 Building status header - status: $status, orderDetail.status: ${orderDetail?.status}, invalidDatetime: ${orderDetail?.invalidDatetime}',
    );

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
        // Format invalidDatetime
        String expiryTime = '00:00:00';
        if (orderDetail?.invalidDatetime != null) {
          try {
            final dt = DateTime.fromMillisecondsSinceEpoch(
              orderDetail!.invalidDatetime!,
            );
            expiryTime =
                '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
            AppLogger.d(
              '✅ Formatted expiry time: $expiryTime from timestamp: ${orderDetail!.invalidDatetime}',
            );
          } catch (e) {
            AppLogger.d('❌ Error formatting invalidDatetime: $e');
          }
        } else {
          AppLogger.d('⚠️ invalidDatetime is null');
        }
        subtitle =
            'Order will be held until $expiryTime and will be cancelled after deadline';
        AppLogger.d('📝 Final subtitle: $subtitle');
        break;
      case OrderStatus.pendingReleased:
        iconPath = 'assets/icons/orders/lock.svg';
        bgColor = const Color(0xFFFFFBF6);
        title = 'Pending Released';
        subtitle = null;
        break;
      case OrderStatus.completed:
        iconPath = 'assets/icons/orders/tick-circle.svg';
        bgColor = const Color(0xffEAF9F0);
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
            Builder(
              builder: (context) {
                // Extract time from subtitle
                String displayTime = '00:00:00';
                if (orderDetail?.invalidDatetime != null) {
                  try {
                    final dt = DateTime.fromMillisecondsSinceEpoch(
                      orderDetail!.invalidDatetime!,
                    );
                    displayTime =
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
                  } catch (e) {
                    AppLogger.d('Error in RichText formatting: $e');
                  }
                }
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF425665),
                      fontFamily: 'Inter',
                    ),
                    children: [
                      const TextSpan(text: 'Order will be held until '),
                      TextSpan(
                        text: displayTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF151E2F),
                        ),
                      ),
                      const TextSpan(
                        text: ' and will be cancelled after deadline',
                      ),
                    ],
                  ),
                );
              },
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
    final amount = orderDetail?.tradeAmount?.toString() ?? '0';
    final currency = orderDetail?.tradeCurrency ?? 'USD';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151E2F),
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(text: '$amount '),
              TextSpan(
                text: currency,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: amount));
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
    // final time = orderDetail?.createDatetime != null
    //     ? OrderHelper.formatDateTime(orderDetail!.createDatetime)
    //     : 'N/A';
    final quantity =
        '${orderDetail?.count ?? '0'} ${orderDetail?.tradeCoin ?? ''}';
    final total =
        '${orderDetail?.tradeAmount ?? '0'} ${orderDetail?.tradeCurrency ?? ''}';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // _buildStatColumn('Time', time, CrossAxisAlignment.start),
            _buildStatColumn(
              'Quantity(${orderDetail?.tradeCoin ?? 'COIN'})',
              orderDetail?.count?.toString() ?? '0',
              CrossAxisAlignment.start,
            ),
            _buildStatColumn(
              'Total(${orderDetail?.tradeCurrency ?? 'USD'})',
              orderDetail?.tradeAmount?.toString() ?? '0',
              CrossAxisAlignment.center,
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
    final counterpartyName = isSeller
        ? (orderDetail?.buyerNickname ?? 'Unknown')
        : (orderDetail?.sellerNickname ?? 'Unknown');
    final counterpartyPhoto = isSeller
        ? (orderDetail?.buyerPhoto)
        : (orderDetail?.sellerPhoto);
    final counterpartyLabel = isSeller ? 'Buyer' : 'Seller';

    return Column(
      children: [
        _buildDetailRow(
          counterpartyLabel,
          counterpartyName,
          hasAvatar: true,
          avatarPath:
              counterpartyPhoto ?? 'assets/images/avatar_placeholder.png',
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Order No', orderDetail?.id ?? 'N/A', hasCopy: true),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Order Time',
          orderDetail?.createDatetime != null
              ? OrderHelper.formatDateTimeFull(orderDetail!.createDatetime)
              : 'N/A',
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Payment Methods',
          'Bank Cards',
          valueColor: const Color(0xFF1E2C37),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Bank',
          orderDetail?.bankName ?? 'N/A',
          valueColor: const Color(0xFF1E2C37),
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Account Name',
          orderDetail?.realName ?? 'N/A',
          valueColor: const Color(0xFF1E2C37),
        ),
        // const SizedBox(height: 12),
        // _buildDetailRow(
        //   'Bank Branches',
        //   'todo',
        //   valueColor: const Color(0xFF1E2C37),
        // ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Bank Number',
          orderDetail?.bankcardNumber ?? 'N/A',
          hasCopy: true,
        ),
        // const SizedBox(height: 12),
        // _buildDetailRow(
        //   'Buyer',
        //   orderDetail?.buyerNickname ?? 'N/A',
        //   hasAvatar: true,
        //   avatarPath:
        //       orderDetail?.buyerPhoto ?? 'assets/images/avatar_placeholder.png',
        // ),
        const SizedBox(height: 12),
        if (orderDetail?.leaveMessage?.isNotEmpty ?? false)
          _buildDetailRow('Ads Messages', orderDetail!.leaveMessage!),
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
                  child: avatarPath.startsWith('http')
                      ? Image.network(
                          avatarPath,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 24,
                              height: 24,
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 16),
                            );
                          },
                        )
                      : Image.asset(
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
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _showCancelOrderBottomSheet,
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
                onPressed: _showNotifyPaymentDialog,
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
        //seller view
        if (isSeller) {
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _showArbitrationBottomSheet,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 4,
                    ),
                    side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Text(
                      'Request for Arbitration',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D5DE5),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showConfirmReleaseDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go Release',
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
        } else {
          // Buyer view: Only Arbitration
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showArbitrationBottomSheet,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 4,
                ),
                side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: const Text(
                  'Request for Arbitration',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D5DE5),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }

      case OrderStatus.cryptoReleased:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showRateExperienceBottomSheet,
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

  void _showConfirmReleaseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmReleaseDialog(
        onConfirm: (pin) {
          _handleReleaseOrder(pin);
        },
      ),
    );
  }

  Future<void> _handleReleaseOrder(String pin) async {
    _showLoadingDialog();
    try {
      await P2PApi.releaseOrder(widget.orderId, pin);
      _hideLoadingDialog();
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Order released successfully",
      );
      _fetchOrderDetail();
    } catch (e) {
      _hideLoadingDialog();
      CustomSnackbar.showError(title: "Error", message: e.toString());
    }
  }
}
