import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void showVerifiedMerchantBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF929EB8), width: 1),
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Success Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE9FBEF),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/merchant_details/tick-circle.svg',
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            "Congratulations",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF151E2F),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          const Text(
            "You are a new verified merchant. you can start posting ads",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Post ads button
          PrimaryButton(
            text: "Posting Ads Now",
            enabled: true,
            onPressed: () async {
              Navigator.pop(context); // pop model sheet first
              // final result =
              await Get.toNamed(Routes.postAdsPage);
              // refresh after coming back
              // if (result == true) {
              // await _controller.callRefresh();
              // _fetchAds(isRefresh: true);
              // }
            },
          ),
          const SizedBox(height: 16),
          // Back to Home Button
          TextButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: SvgPicture.asset(
              'assets/icons/merchant_details/arrow_left.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1D5DE5),
                BlendMode.srcIn,
              ),
            ),
            label: const Text(
              "Back to Home",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF1D5DE5),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}
