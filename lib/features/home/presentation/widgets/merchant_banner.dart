import 'package:flutter/material.dart';

class MerchantBanner extends StatelessWidget {
  const MerchantBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D5DE50F).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff4A7DEA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/home/merchant.png',
              width: 19,
              height: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Become a merchant",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4A7DEA),
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Apply to start accepting crypto payments",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff151E2F),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/icons/home/arrow_right.png',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
