import 'package:flutter/material.dart';

class FriendlyReminderCard extends StatelessWidget {
  const FriendlyReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffE8EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/deposit/lightbulb.png",
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Friendly Reminder",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1D5DE5),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "The deposit might take upto 5 mins for USDT and upto 30 mins for BTC to reflect in your wallet as the transactions depends on the network congestion and confirmations.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff454F63),
                    height: 1.4,
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
