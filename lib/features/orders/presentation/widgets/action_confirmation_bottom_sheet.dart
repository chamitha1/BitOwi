import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

enum ActionType { cancelOrder, arbitration }

class ActionConfirmationBottomSheet extends StatefulWidget {
  final ActionType actionType;

  const ActionConfirmationBottomSheet({super.key, required this.actionType});

  @override
  State<ActionConfirmationBottomSheet> createState() =>
      _ActionConfirmationBottomSheetState();
}

class _ActionConfirmationBottomSheetState
    extends State<ActionConfirmationBottomSheet> {
  bool isConfirmed = false;

  String get title {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return 'Cancel Order';
      case ActionType.arbitration:
        return 'Please Confirm';
    }
  }

  String get warningTitle {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return 'Do not cancel this order';
      case ActionType.arbitration:
        return 'Do not request for Arbitration';
    }
  }

  String get warningBody {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return 'Do not cancel the order if you have already paid the seller';
      case ActionType.arbitration:
        return 'Do not request for arbitration if you have received the full payment from the seller. any malicious intent will result in your account being frozen.';
    }
  }

  String get checkboxText {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return "I haven't paid to other party yet";
      case ActionType.arbitration:
        return "I haven't received payment from the buyer yet";
    }
  }

  String get primaryButtonLabel {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return 'Cancel Order';
      case ActionType.arbitration:
        return 'Confirm';
    }
  }

  String get secondaryButtonLabel {
    switch (widget.actionType) {
      case ActionType.cancelOrder:
        return 'Close';
      case ActionType.arbitration:
        return 'Cancel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDAE0EE),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF151E2F),
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Warning Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4F5),
                    border: Border.all(color: const Color(0xFFF5B7B1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/orders/info-circle.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFCF4436),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              warningTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFCF4436),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              warningBody,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFCF4436),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Policy only for cancel
                if (widget.actionType == ActionType.cancelOrder) ...[
                  const Text(
                    'Order Cancellation Policy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF151E2F),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "If a buyer cancels three orders in single day they won't be able to create new buy orders for the rest of the day",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF717F9A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Confirmation Checkbox
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isConfirmed = !isConfirmed;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFDAE0EE),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: isConfirmed
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1D5DE5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          checkboxText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2E3D5B),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                //Action Button
                ElevatedButton(
                  onPressed: isConfirmed
                      ? () {
                          Get.back(result: true);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    disabledBackgroundColor: const Color(
                      0xFF1D5DE5,
                    ).withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    primaryButtonLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                //Action Button
                TextButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: Text(
                    secondaryButtonLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF717F9A),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
