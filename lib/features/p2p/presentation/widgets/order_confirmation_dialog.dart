import 'package:flutter/material.dart';

class OrderConfirmationDialog extends StatelessWidget {
  final String type; // "Buying" or "Selling"
  final String price;
  final String amount;
  final String qty;
  final VoidCallback onConfirm;

  const OrderConfirmationDialog({
    super.key,
    required this.type,
    required this.price,
    required this.amount,
    required this.qty,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String type,
    required String price,
    required String amount,
    required String qty,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => OrderConfirmationDialog(
        type: type,
        price: price,
        amount: amount,
        qty: qty,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              "Order Confirmation",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),
            const SizedBox(height: 24),

            // Row 1: Price
            _buildRow("$type Price", price),
            const SizedBox(height: 12),

            // Row 2: Amount
            _buildRow("$type Amount", amount),
            const SizedBox(height: 12),

            // Row 3: Qty
            _buildRow("$type Qty", qty),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF1D5DE5),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "No, Thanks",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D5DE5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5DE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Confirm $type",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF717F9A),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF151E2F),
          ),
        ),
      ],
    );
  }
}
