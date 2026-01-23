import 'package:BitOwi/features/p2p/presentation/pages/p2p_buy_screen.dart';
import 'package:BitOwi/features/p2p/presentation/pages/p2p_sell_screen.dart';

import 'package:BitOwi/models/ads_page_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/profile/presentation/pages/merchant_profile_page.dart';

import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/core/widgets/confirm_dialog.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';

class P2POrderCard extends StatelessWidget {
  final bool isBuy;
  final AdItem? adItem;
  final VoidCallback? onRefresh;

  const P2POrderCard({
    super.key,
    this.isBuy = true,
    this.adItem,
    this.onRefresh,
  });

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
                    GestureDetector(
                      onTap: () {
                        if (adItem?.userId != null) {
                          Get.to(
                            () => const MerchantProfilePage(),
                            arguments: adItem!.userId,
                          );
                        }
                      },
                      child: Row(
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
                                      BorderSide(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
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
                        ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            ],
          ),
          const SizedBox(height: 16),
          // Info Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Row
              _buildInfoRow(
                "Total",
                "${adItem?.leftCount ?? '0'} ${adItem?.tradeCoin ?? ''}",
              ),
              const SizedBox(height: 8),
              // Limit Row
              _buildInfoRow(
                "Limit",
                "${_getCurrencySymbol(adItem?.tradeCurrency)}${adItem?.minTrade ?? '0'} - ${_getCurrencySymbol(adItem?.tradeCurrency)}${adItem?.maxTrade ?? '0'}",
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Payment Methods
          Row(
            children: [
              Builder(
                builder: (context) {
                  final hasBank = adItem?.bankPic != null;
                  final payTypeDisplay = hasBank
                      ? (adItem?.bankName ?? 'Bank Transfer')
                      : 'Mobile';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: hasBank
                          ? const Color(0xFFFDF4F5)
                          : const Color(0xFFFFFBF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      payTypeDisplay,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: hasBank
                            ? const Color(0xFFE74C3C)
                            : const Color(0xFFFF9B29),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFECEFF5)),
          const SizedBox(height: 16),
          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 70,
              height: 36,
              child: Builder(
                builder: (context) {
                  final currentUser = Get.find<UserController>().user.value;
                  final isMine =
                      currentUser?.id != null &&
                      adItem?.userId != null &&
                      currentUser!.id == adItem!.userId;

                  if (isMine) {
                    return ElevatedButton.icon(
                      onPressed: () => _onOffTap(context),
                      icon: SvgPicture.asset(
                        'assets/icons/profile_page/toggle_off_circle.svg',
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text(
                        'Off',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D5DE5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    );
                  }

                  return ElevatedButton(
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
                            builder: (context) =>
                                P2PSellScreen(adItem: adItem!),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5DE5),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          isBuy
                              ? 'assets/icons/orders/arrow-down-left.svg'
                              : 'assets/icons/orders/arrow-up-right.svg',
                          width: 16,
                          height: 16,

                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),

                        const SizedBox(width: 4),
                        Text(
                          isBuy ? "Buy" : "Sell",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF929EB8),
            ),
          ),
        ),
        const Text(
          " : ",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF929EB8),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF151E2F),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _onOffTap(BuildContext context) {
    if (adItem?.id == null) return;

    showCommonConfirmDialog(
      context,
      title: "Confirmation to Off",
      message:
          "This ad will be moved to Archived and will no longer be visible to other users. Once archived, this action cannot be undone",
      primaryText: "Confirm",
      secondaryText: "Cancel",
      onPrimary: () async {
        try {
          // 0 = Archive
          await C2CApi.upDownAds(adItem!.id!, "0");

          CustomSnackbar.showSuccess(
            title: "Success",
            message: "Ad turned off successfully",
          );

          // Trigger refresh
          if (onRefresh != null) {
            onRefresh!();
          }
        } catch (e) {
          debugPrint("Off ad error: $e");
          CustomSnackbar.showError(
            title: "Error",
            message: "Something went wrong",
          );
        }
      },
      onSecondary: () {
        debugPrint("User cancelled off ad");
      },
    );
  }
}
