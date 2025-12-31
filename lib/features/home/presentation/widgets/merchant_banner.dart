import 'package:BitOwi/features/merchant/presentation/pages/become_merchant_page.dart';
import 'package:flutter/material.dart';

class MerchantBanner extends StatelessWidget {
  final String merchantStatus;

  const MerchantBanner({super.key, required this.merchantStatus});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BecomeMerchantPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: config.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: config.containerBoxShadowColor,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: config.iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(config.iconPath, width: 20, height: 20),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: config.titleColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    config.subtitle,
                    style: const TextStyle(
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
              "assets/icons/home/arrow_right.png",
              color: config.iconBackground,
            ),
          ],
        ),
      ),
    );
  }

  // Config per state
  _MerchantBannerConfig _getConfig() {
    switch (merchantStatus) {
      /// Become a Merchant
      case '-1': // Not initiated
      case '2': // Review failed
      case '4': // Decertification
        return _MerchantBannerConfig(
          title: "Become a merchant",
          subtitle: "Apply to start accepting crypto payments",
          iconPath: "assets/icons/home/merchant.png",
          backgroundColor: Colors.white,
          borderColor: const Color(0xffD1DEF9),
          iconBackground: const Color(0xff4A7DEA),
          titleColor: const Color(0xff4A7DEA),
          arrowColor: const Color(0xff4A7DEA),
          containerBoxShadowColor: const Color(0xff1D5DE5).withOpacity(0.06),
        );

      /// In Review
      case '0': // Under review
      case '3': // Decertification under review
        return _MerchantBannerConfig(
          title: "In Review...",
          subtitle: "Security and compliance checks in progress",
          iconPath: "assets/icons/home/timer.png",
          backgroundColor: const Color(0xffFFF6EC),
          borderColor: const Color(0xffFFD9B0),
          iconBackground: const Color(0xffF59E0B),
          titleColor: const Color(0xffF59E0B),
          arrowColor: const Color(0xffF59E0B),
          containerBoxShadowColor: const Color(0xffFF9B29).withOpacity(0.06),
        );

      /// Certified Merchant
      case '1': // Review passed
        return _MerchantBannerConfig(
          title: "Certified Merchant",
          subtitle: "You're approved and ready to accept payments",
          iconPath: "assets/icons/home/tick_circle.png",
          backgroundColor: const Color(0xffEAF9F0),
          borderColor: const Color(0xffABEAC6),
          iconBackground: const Color(0xff40A372),
          titleColor: const Color(0xff40A372),
          arrowColor: const Color(0xff40A372),
          containerBoxShadowColor: const Color(0xffECC71).withOpacity(0.08),
        );

      default:
        return _MerchantBannerConfig(
          title: "Become a merchant",
          subtitle: "Apply to start accepting crypto payments",
          iconPath: "assets/icons/home/merchant.png",
          backgroundColor: Colors.white,
          borderColor: const Color(0xffD1DEF9),
          iconBackground: const Color(0xff4A7DEA),
          titleColor: const Color(0xff4A7DEA),
          arrowColor: const Color(0xff4A7DEA),
          containerBoxShadowColor: const Color(0xff1D5DE5).withOpacity(0.06),
        );
    }
  }
}

//  Internal config model
class _MerchantBannerConfig {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackground;
  final Color titleColor;
  final Color arrowColor;
  final Color containerBoxShadowColor;

  _MerchantBannerConfig({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackground,
    required this.titleColor,
    required this.arrowColor,
    required this.containerBoxShadowColor,
  });
}
