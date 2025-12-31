import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReminderCard extends StatelessWidget {
  final String merchantStatus;
  final String identifyOrderLatestSubmittedInfoStatus;

  const ReminderCard({
    super.key,
    required this.merchantStatus,
    required this.identifyOrderLatestSubmittedInfoStatus,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
              config.iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(config.iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: config.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  config.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: config.textColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ReminderConfig _getConfig() {
    // if merchant KYC stil not applied
    if ((merchantStatus == '-1')) {
      if (identifyOrderLatestSubmittedInfoStatus == '') {
        return _ReminderConfig(
          title: "Important",
          description:
              "KYC verification typically takes 1-24 hours. You'll be notified when approved.",
          backgroundColor: const Color(0xFFFFFBF6),
          borderColor: const Color(0xFFFFE2C1),
          textColor: const Color(0xFFC9710D),
          iconColor: const Color(0xFFC9710D),
          iconPath: 'assets/icons/merchant_details/info_circle.svg',
        );
      }
      if (identifyOrderLatestSubmittedInfoStatus == '0') {
        return _ReminderConfig(
          title: "Verification Pending",
          description:
              "Your details have been submitted and are currently under review.",
          backgroundColor: const Color(0xFFFFFBF6),
          borderColor: const Color(0xFFFFE2C1),
          textColor: const Color(0xFFC9710D),
          iconColor: const Color(0xFFC9710D),
          iconPath: 'assets/icons/merchant_details/info_circle.svg',
        );
      }
      if (identifyOrderLatestSubmittedInfoStatus == '2') {
        return _ReminderConfig(
          title: "Verification Failed",
          description:
              "We couldn't verify your information. Please review your details and resubmit your KYC.",
          backgroundColor: const Color(0xFFFDF4F5),
          borderColor: const Color(0xFFF5B7B1),
          textColor: const Color(0xFFCF4436),
          iconColor: const Color(0xFFCF4436),
          iconPath: 'assets/icons/merchant_details/info_circle.svg',
        );
      }
      if (identifyOrderLatestSubmittedInfoStatus == '1') {
        return _ReminderConfig(
          title: "Verified User KYC",
          description:
              "Your identity has been verified. You can Apply now for Merchant KYC",
          backgroundColor: const Color(0xFFEAF9F0),
          borderColor: const Color(0xFFABEAC6),
          textColor: const Color(0xFF40A372),
          iconColor: const Color(0xFF40A372),
          iconPath: 'assets/icons/merchant_details/info_circle.svg',
        );
      }
    } 
    // if merchant KYC stil applied even once
    else {
      switch (merchantStatus) {

        case '0':
        case '3':
          return _ReminderConfig(
            title: "Verification Pending",
            description:
                "Your details have been submitted for Merchant KYC Verification and are currently under review.",
            backgroundColor: const Color(0xFFFFFBF6),
            borderColor: const Color(0xFFFFE2C1),
            textColor: const Color(0xFFC9710D),
            iconColor: const Color(0xFFC9710D),
            iconPath: 'assets/icons/merchant_details/info_circle.svg',
          );

        case '2':
          return _ReminderConfig(
            title: "Verification Failed",
            description:
                "We couldn't verify your information. Please review your details and resubmit your KYC.",
            backgroundColor: const Color(0xFFFDF4F5),
            borderColor: const Color(0xFFF5B7B1),
            textColor: const Color(0xFFCF4436),
            iconColor: const Color(0xFFCF4436),
            iconPath: 'assets/icons/merchant_details/info_circle.svg',
          );

        case '4':
          return _ReminderConfig(
            title: "Verified User KYC",
            description:
                "Your identity has been verified. You can Apply now for Merchant KYC",
            backgroundColor: const Color(0xFFEAF9F0),
            borderColor: const Color(0xFFABEAC6),
            textColor: const Color(0xFF40A372),
            iconColor: const Color(0xFF40A372),
            iconPath: 'assets/icons/merchant_details/info_circle.svg',
          );

        case '1':
          return _ReminderConfig(
            title: "Verified Merchant KYC",
            description:
                "Your identity has been verified. You can do Deposit Fund",
            backgroundColor: const Color(0xFFEAF9F0),
            borderColor: const Color(0xFFABEAC6),
            textColor: const Color(0xFF40A372),
            iconColor: const Color(0xFF40A372),
            iconPath: 'assets/icons/merchant_details/info_circle.svg',
          );

        default:
          return _ReminderConfig(
            title: "Important",
            description: "Unknown verification status.",
            backgroundColor: const Color(0xFFF6F9FF),
            borderColor: const Color(0xFFE2E8F0),
            textColor: const Color(0xFF64748B),
            iconColor: const Color(0xFF64748B),
            iconPath: 'assets/icons/merchant_details/info_circle.svg',
          );
      }
    }
    return _ReminderConfig(
      title: "Important",
      description: "Unknown verification status.",
      backgroundColor: const Color(0xFFF6F9FF),
      borderColor: const Color(0xFFE2E8F0),
      textColor: const Color(0xFF64748B),
      iconColor: const Color(0xFF64748B),
      iconPath: 'assets/icons/merchant_details/info_circle.svg',
    );
  }
}

class _ReminderConfig {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final String iconPath;

  _ReminderConfig({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.iconPath,
  });
}
