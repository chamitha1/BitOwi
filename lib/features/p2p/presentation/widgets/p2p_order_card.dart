import 'package:BitOwi/features/p2p/presentation/pages/p2p_buy_screen.dart';
import 'package:BitOwi/features/p2p/presentation/pages/p2p_sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class P2POrderCard extends StatelessWidget {
  final bool isBuy;

  const P2POrderCard({super.key, this.isBuy = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF717F9A).withOpacity(0.07),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x4DECEFF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(
                            'assets/images/home/avatar.png',
                          ),
                          backgroundColor: Color(0xFFE8ECF4),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Byron Hartmann",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const Spacer(),
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/p2p/certified.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Certified",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xFF1D5DE5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Stats
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/p2p/like.svg',
                      width: 12,
                      height: 12,
                      color: const Color(0xFFFF9B29),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "100.0%",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF717F9A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 10,
                      color: const Color(0xFFDAE0EE),
                    ),
                    const SizedBox(width: 8),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF717F9A),
                        ),
                        children: [
                          TextSpan(text: "Trust "),
                          TextSpan(
                            text: "453,657",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF151E2F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 10,
                      color: const Color(0xFFDAE0EE),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF717F9A),
                        ),
                        children: [
                          TextSpan(text: "Trade "),
                          TextSpan(
                            text: "453,657 / 99.9%",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF151E2F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "₦ 23,493.02",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Per USDT",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF717F9A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF929EB8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "2,53,657 USDT",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Limit",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF929EB8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "453,657 / 99.9%",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
              // Right Button
              SizedBox(
                width: 52,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    if (isBuy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const P2PBuyScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const P2PSellScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Text(
                    isBuy ? "Buy" : "Sell",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Payment Methods
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFECEFF5), width: 1),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPaymentTag(
                  "Bank Transfer",
                  const Color(0xFFFFFBF6),
                  const Color(0xFFFF9B29),
                ),
                _buildPaymentTag(
                  "Airtel Money",
                  const Color(0xFFFDF4F5),
                  const Color(0xFFE74C3C),
                ),
                _buildPaymentTag(
                  "MTN Money",
                  const Color(0xFFE8EFFF),
                  const Color(0xFF1D5DE5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
