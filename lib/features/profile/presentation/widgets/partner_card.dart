import 'package:BitOwi/features/profile/presentation/pages/merchant_profile_page.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PartnerItem {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final bool isCertified;
  final String goodRate;
  final int trustCount;
  final int tradeCount;
  final String finishRate;
  final String addedDate;

  PartnerItem({
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.isCertified,
    required this.goodRate,
    required this.trustCount,
    required this.tradeCount,
    required this.finishRate,
    required this.addedDate,
  });
}

class PartnerCard extends StatelessWidget {
  final PartnerItem item;

  const PartnerCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const MerchantProfilePage());
      },
      child: Container(
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x73F6F9FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  //Header Info
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE0E0E0),
                            ),
                            child: ClipOval(
                              child: CommonImage(
                                item.avatarUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (item.isOnline)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C076),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Name and Badge
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF151E2F),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.isCertified) ...[
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
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
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/profile_page/like.svg',
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${item.goodRate}%",
                            style: _statTextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      _buildDivider(),
                      // Trust Count
                      Row(
                        children: [
                          Text(
                            "Trust ",
                            style: _statTextStyle(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${item.trustCount}",
                            style: _statTextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      _buildDivider(),
                      // Trade Count
                      Row(
                        children: [
                          Text(
                            "Trade ",
                            style: _statTextStyle(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${item.tradeCount} / ${item.finishRate}%",
                            style: _statTextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Added on",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF717F9A),
                  ),
                ),
                Text(
                  item.addedDate,
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
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 14, color: const Color(0xFFDAE0EE));
  }

  TextStyle _statTextStyle({required FontWeight fontWeight}) {
    return TextStyle(
      fontSize: 12,
      fontFamily: 'Inter',
      color: const Color(0xFF717F9A), 
      fontWeight: fontWeight,
    );
  }
}
