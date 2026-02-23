import 'package:BitOwi/features/p2p/presentation/widgets/download_app_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/profile/presentation/pages/chat/chat.dart';
import 'package:BitOwi/utils/im_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BitOwi/core/widgets/common_image.dart';

enum OrderStatus {
  pending,
  pendingPayment,
  pendingReleased,
  completed,
  cancelled,
  arbitration,
  cryptoReleased,
}

class OrderCard extends StatelessWidget {
  final String orderNo;
  final OrderStatus status;
  final String title;
  final String date;
  final String quantity;
  final String total;
  final String userAvatar;
  final String userName;
  final bool isCertified;
  final bool hasUnreadMessages;
  final String? targetUserId;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.orderNo,
    required this.status,
    required this.title,
    required this.date,
    required this.quantity,
    required this.total,
    required this.userAvatar,
    required this.userName,
    this.isCertified = false,
    this.hasUnreadMessages = false,
    this.targetUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🚀🚀🚀🚀  hasUnreadMessages :${hasUnreadMessages}");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12717F9A),
              offset: Offset(0, 3),
              blurRadius: 9,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order No",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF717F9A),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderNo.length > 8
                          ? '${orderNo.substring(0, 8)}...'
                          : orderNo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF151E2F),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildStatusBadge(),
                    // Only show chat icon for pending order and arbitration
                    // if (status == OrderStatus.pending ||
                    //     status == OrderStatus.arbitration) ...[
                    //   const SizedBox(width: 12),
                    //   _buildChatIcon(context, orderNo),
                    // ],
                    if (hasUnreadMessages) _buildChatIcon(context, orderNo),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFECEFF5)),
            const SizedBox(height: 12),

            // Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101828),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDataColumn("Time", date, CrossAxisAlignment.start),
                _buildDataColumn(
                  "Quantity(ETH)",
                  quantity,
                  CrossAxisAlignment.center,
                ),
                _buildDataColumn("Total(NGN)", total, CrossAxisAlignment.end),
              ],
            ),
            const SizedBox(height: 12),

            //User Info
            GestureDetector(
              onTap: () {
                if (targetUserId != null) {
                  Get.toNamed(
                    '/merchantProfile',
                    arguments: targetUserId,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFF5).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CommonImage(userAvatar, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF151E2F),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const Spacer(),
                    if (isCertified) _buildCertifiedBadge(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String iconName;
    String text;

    switch (status) {
      case OrderStatus.pending:
        bgColor = const Color(0xFFFFFBF6);
        textColor = const Color(0xFFFF9B29);
        iconName = "clock-three.svg";
        text = "Pending Order";
        break;
      case OrderStatus.pendingPayment:
        bgColor = const Color(0xFFFFFBF6);
        textColor = const Color(0xFFFF9B29);
        iconName = "clock-three.svg";
        text = "Pending Buyer Payment";
        break;
      case OrderStatus.pendingReleased:
        bgColor = const Color(0xFFFFFBF6);
        textColor = const Color(0xFFFF9B29);
        iconName = "lock.svg";
        text = "Pending Released";
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFEAF9F0);
        textColor = const Color(0xFF40A372);
        iconName = "tick-circle.svg";
        text = "Completed";
        break;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFDF4F5);
        textColor = const Color(0xFFE74C3C);
        iconName = "close-circle.svg";
        text = "Cancelled";
        break;
      case OrderStatus.arbitration:
        bgColor = const Color(0xFFFFFBF6);
        textColor = const Color(0xFFFF9B29);
        iconName = "scale.svg";
        text = "Arbitration";
        break;
      case OrderStatus.cryptoReleased:
        bgColor = const Color(0xFFEAF9F0);
        textColor = const Color(0xFF40A372);
        iconName = "note-2.svg";
        text = "Crypto Released";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/orders/$iconName',
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatIcon(BuildContext context, String id) {
    return GestureDetector(
      onTap: () async {
        if (!kIsWeb ) {
          // 🔹 Build group conversation ID
          final String groupId = 'group_$id';

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            'assets/icons/orders/messages.svg',
            width: 20,
            height: 20,
          ),
          if (hasUnreadMessages) // no need anyway enabled
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C3C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataColumn(
    String label,
    String value,
    CrossAxisAlignment alignment,
  ) {
    return Column(
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
        const SizedBox(height: 4),
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
    );
  }

  Widget _buildCertifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/profile_page/shield.svg',
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1D5DE5),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            "Certified",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xFF1D5DE5),
            ),
          ),
        ],
      ),
    );
  }
}
