import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/features/profile/presentation/widgets/merchant_ad_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MerchantProfilePage extends StatelessWidget {
  final String merchantName;
  final String avatarUrl;
  final bool isCertified;

  const MerchantProfilePage({
    super.key,
    this.merchantName = "Terence Welch",
    this.avatarUrl = "assets/images/home/avatar.png",
    this.isCertified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Partners",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF151E2F),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            const Text(
              "Merchant Ads",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF151E2F),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF779DEF), width: 3),
                ),
                child: ClipOval(
                  child: CommonImage(avatarUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isCertified) ...[
                      const SizedBox(height: 4),
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
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
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
                    const Text(
                      "98%",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
                const Row(
                  children: [
                    Text(
                      "Trust ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors
                            .white, 
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "124",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
                const Row(
                  children: [
                    Text(
                      "Trade ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "450 / 99%",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight:
                            FontWeight.w600, 
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  iconPath: 'assets/icons/profile_page/tick-square.svg',
                  label: "Trust",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  iconPath: 'assets/icons/profile_page/card-send.svg',
                  label: "Blacklist",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String iconPath, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D5DE5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331D5DE5),
            offset: Offset(0, 6),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdList() {
    final items = List.generate(
      3,
      (index) => MerchantAdItem(
        name: "Matthew Schuster",
        avatarUrl: "assets/images/home/avatar.png",
        isCertified: true,
        goodRate: "98",
        trustCount: 124,
        tradeCount: 450,
        finishRate: "99",
        price: "₦ 15,654.32",
        totalAmount: "0.0456 BTC",
        limit: "₦ 5,000 - ₦ 500,000",
        paymentMethods: ["Bank Transfer", "Airtel Money"],
      ),
    );

    return Column(
      children: items.map((item) => MerchantAdCard(item: item)).toList(),
    );
  }
}
