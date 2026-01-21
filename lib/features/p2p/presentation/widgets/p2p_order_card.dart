import 'package:BitOwi/features/p2p/presentation/pages/p2p_buy_screen.dart';
import 'package:BitOwi/features/p2p/presentation/pages/p2p_sell_screen.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class P2POrderCard extends StatelessWidget {
  final bool isBuy;
  final AdItem? adItem;

  const P2POrderCard({super.key, this.isBuy = true, this.adItem});

  @override
  Widget build(BuildContext context) {
    if (adItem == null) return const SizedBox();

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
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: adItem?.photo != null
                              ? NetworkImage(adItem!.photo!)
                              : const AssetImage(
                                      'assets/images/home/avatar.png',
                                    )
                                    as ImageProvider,
                          backgroundColor: const Color(0xFFE8ECF4),
                        ),
                        // Online Status
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
                    Text(
                      adItem?.nickname ?? "User",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const Spacer(),
                    // Badge Logic
                    if (adItem?.userStatistics?.isTrust == '1')
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
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF9B29),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${adItem?.userStatistics?.commentGoodCount ?? 0}%",
                      style: const TextStyle(
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
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF717F9A),
                        ),
                        children: [
                          const TextSpan(text: "Trust "),
                          TextSpan(
                            text: "${adItem?.userStatistics?.orderCount ?? 0}",
                            style: const TextStyle(
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
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF717F9A),
                        ),
                        children: [
                          const TextSpan(text: "Trade "),
                          TextSpan(
                            text:
                                "${adItem?.userStatistics?.orderCount ?? 0} / ${adItem?.userStatistics?.orderFinishCount ?? 0}%",
                            style: const TextStyle(
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
          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${_getCurrencySymbol(adItem?.tradeCurrency)} ${double.tryParse(adItem?.truePrice ?? '0')?.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Per ${adItem?.tradeCoin ?? 'USDT'}",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF717F9A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Info & Action Row
          Row(
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
                  Text(
                    "${double.tryParse(adItem?.leftCount ?? '0')?.toStringAsFixed(1) ?? '0.0'} ${adItem?.tradeCoin ?? ''}",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
                  Text(
                    "${_getCurrencySymbol(adItem?.tradeCurrency)}${double.tryParse(adItem?.minTrade ?? '0')?.toStringAsFixed(1) ?? '0.0'} - ${_getCurrencySymbol(adItem?.tradeCurrency)}${double.tryParse(adItem?.maxTrade ?? '0')?.toStringAsFixed(1) ?? '0.0'}",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 76,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    if (isBuy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => P2PBuyScreen(adItem: adItem!),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => P2PSellScreen(adItem: adItem!),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1D5DE5,
                    ), 
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
          const SizedBox(height: 16),
          // Payment Methods
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
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
                  adItem?.bankName ?? "Bank Transfer",
                  const Color(0xFFFFF9C4),
                  const Color(0xFFFBC02D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String? currency) {
    switch (currency) {
      case 'NGN':
        return '₦';
      case 'USD':
        return '\$';
      default:
        return '';
    }
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
