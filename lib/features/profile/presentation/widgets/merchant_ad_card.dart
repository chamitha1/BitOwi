import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MerchantAdItem {
  final String name;
  final String avatarUrl;
  final bool isCertified;
  final String goodRate;
  final int trustCount;
  final int tradeCount;
  final String finishRate;
  final String price;
  final String totalAmount;
  final String limit;
  final List<String> paymentMethods;

  MerchantAdItem({
    required this.name,
    required this.avatarUrl,
    required this.isCertified,
    required this.goodRate,
    required this.trustCount,
    required this.tradeCount,
    required this.finishRate,
    required this.price,
    required this.totalAmount,
    required this.limit,
    required this.paymentMethods,
  });
}

class MerchantAdCard extends StatelessWidget {
  final MerchantAdItem item;

  const MerchantAdCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F717F9A),
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE0E0E0),
                ),
                child: ClipOval(
                  child: CommonImage(item.avatarUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF151E2F),
                ),
              ),
              if (item.isCertified) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/icons/profile_page/shield.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1D5DE5),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Stats Row
          Row(
            children: [
              _buildStatItem(
                "${item.goodRate}%",
                'assets/icons/profile_page/like.svg',
              ),
              _buildDivider(),
              _buildStatItem("Trust ${item.trustCount}", null),
              _buildDivider(),
              _buildStatItem(
                "Trade ${item.tradeCount} / ${item.finishRate}%",
                null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Price
          Text(
            item.price,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 12),
          // Limits Row
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
                      fontSize: 12,
                      color: Color(0xFF717F9A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.totalAmount,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Limit",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF717F9A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.limit,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Payment Methods
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFECEFF5), width: 1),
                bottom: BorderSide(color: Color(0xFFECEFF5), width: 1),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.paymentMethods.map((method) {
                Color bgColor;
                Color textColor;

                if (method == "Bank Transfer") {
                  bgColor = const Color(0xFFFFFBF6);
                  textColor = const Color(0xFFFF9B29);
                } else if (method == "Airtel Money") {
                  bgColor = const Color(0xFFFDF4F5);
                  textColor = const Color(0xFFE74C3C);
                } else {
                  bgColor = const Color(0xFFE8EFFF);
                  textColor = const Color(0xFF1D5DE5);
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    method,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Action btns
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1D5DE5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/profile_page/arrow-down-left.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Buy Ad",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1D5DE5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D5DE5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x331D5DE5),
                        offset: Offset(0, 6),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/profile_page/arrow-up-right.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Sell Ad",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, String? iconPath) {
    return Row(
      children: [
        if (iconPath != null) ...[
          SvgPicture.asset(iconPath, width: 14, height: 14),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF717F9A),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      height: 12,
      color: const Color(0xFFDAE0EE),
    );
  }
}
