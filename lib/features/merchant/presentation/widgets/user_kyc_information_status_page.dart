import 'package:BitOwi/features/merchant/presentation/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class UserKycStatusPage extends StatelessWidget {
  final int countryIndex;
  final List<dynamic> countryList;
  final int idTypeIndex;
  final List<dynamic> idTypeList;
  final String name;
  final String idNumber;
  final DateTime? expiryDate;
  final String merchantStatus;
  final String identifyOrderLatestSubmittedInfoStatus;

  const UserKycStatusPage({
    super.key,
    required this.countryIndex,
    required this.countryList,
    required this.idTypeIndex,
    required this.idTypeList,
    required this.name,
    required this.idNumber,
    required this.expiryDate,
    required this.merchantStatus,
    required this.identifyOrderLatestSubmittedInfoStatus,
  });

  @override
  Widget build(BuildContext context) {
    final countryName = countryIndex >= 0 && countryIndex < countryList.length
        ? countryList[countryIndex].interName
        : '-';

    final idTypeName = idTypeIndex >= 0 && idTypeIndex < idTypeList.length
        ? idTypeList[idTypeIndex].value
        : '-';

    final formattedDate = expiryDate == null
        ? '-'
        : DateFormat('MMM dd yyyy').format(expiryDate!);

    return Column(
      children: [
        const SizedBox(height: 24),

        /// Success Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E).withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF22C55E),
                  size: 36,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Successfully Submitted",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xFF151E2F),
                ),
              ),

              const SizedBox(height: 8),

              if (merchantStatus == '0')
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: const Text(
                    "Your verification details have been received and are currently under review",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ),

              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),

              const Text(
                "KYC Information",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),

              const SizedBox(height: 16),

              _infoRow("Nationality", countryName),
              _infoRow("Name", name),
              _infoRow("ID Type", idTypeName),
              _infoRow("ID Number", idNumber),
              _infoRow("Expiry Date", formattedDate),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Reminder
        // ReminderCard(
        //   merchantStatus: merchantStatus,
        //   identifyOrderLatestSubmittedInfoStatus:
        //       identifyOrderLatestSubmittedInfoStatus,
        // ),
        userKYCRemindCard(),
        const SizedBox(height: 40),
      ],
    );
  }

  Container userKYCRemindCard() {
    final bool isRejected = merchantStatus == '2'; // wont come here
    final bool isApproved = merchantStatus == '1';
    final bool isPending = merchantStatus == '0';

    final Color backgroundColor = isRejected
        ? const Color(0xFFFDF4F5)
        : isApproved
        ? const Color(0xFFEAF9F0)
        : const Color(0xFFFFFBF6);

    final Color borderColor = isRejected
        ? const Color(0xFFF5B7B1)
        : isApproved
        ? const Color(0xFFABEAC6)
        : const Color(0xFFFFE2C1);

    final Color textColor = isRejected
        ? const Color(0xFFCF4436)
        : isApproved
        ? const Color(0xFF40A372)
        : const Color(0xFFC9710D);

    final Color iconColor = isRejected
        ? const Color(0xFFCF4436)
        : isApproved
        ? const Color(0xFF40A372)
        : const Color(0xFFC9710D);

    final String title = isRejected
        ? 'KYC Verification Failed'
        : isApproved
        ? 'KYC Verification Successful'
        : 'KYC Verification Pending';

    final String description = isRejected
        ? 'Please resubmit your information.'
        : isApproved
        ? 'Your verification has been approved.'
        : 'Your details have been submitted and are currently under review';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
              'assets/icons/merchant_details/info_circle.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: textColor,
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

  /// Info Row Helper (kept private to this file)
  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF1E2C37),
            ),
          ),
        ],
      ),
    );
  }
}
