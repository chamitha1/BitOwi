import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/features/address_book/presentation/pages/address_book_page.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/merchant/presentation/pages/user_kyc_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:BitOwi/features/profile/presentation/pages/account_security_page.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/user_kyc_personal_information_controller.dart';
import 'package:BitOwi/features/notifications/presentation/pages/notifications_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/partners_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 56, child: _buildTopBar(userController)),
              const SizedBox(height: 20),
              _buildProfileCard(userController),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: _buildQuickActionsRow(),
              ),
              const SizedBox(height: 24),
              _buildMenuCards(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(UserController userController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            color: Color(0xFF151E2F),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 12),
            Obx(
              () => _buildCircleIconButton(
                icon: SvgPicture.asset(
                  'assets/icons/profile_page/notification.svg',
                ),
                onTap: () {
                  Get.to(() => const NotificationsPage())?.then((_) {
                    userController.fetchNotificationCount();
                  });
                },
                badgeCount: userController.notificationCount.value > 0
                    ? userController.notificationCount.value
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required Widget icon,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFECEFF5)),
            ),
            child: Center(child: icon),
          ),
          if (badgeCount != null)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4D4F),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF28A6FF), Color(0xFF1D5DE5)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Obx(() {
                  return buildAvatar(controller.userAvatar.value);
                }),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Text(
                          controller.userName.value,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        );
                      }),
                      // Certified Badge
                      Obx(
                        () => (controller.user.value?.merchantStatus == '1')
                            ? Container(
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
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stats Row
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                    Obx(
                      () => Text(
                        "${controller.goodRate}%",
                        style: _statTextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
                Row(
                  children: [
                    Text(
                      "Trust ",
                      style: _statTextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        "${controller.tradeInfo.value?.confidenceCount ?? 0}",
                        style: _statTextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
                Row(
                  children: [
                    Text(
                      "Trade ",
                      style: _statTextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        "${controller.tradeInfo.value?.totalTradeCount ?? "0"} / ${controller.finishRate}%",
                        style: _statTextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAvatar(String avatar) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.mePage);
      },
      child: Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF779DEF),
        ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(child: CommonImage(avatar, fit: BoxFit.cover)),
      ),
    );
  }

  TextStyle _statTextStyle({required FontWeight fontWeight}) {
    return TextStyle(
      fontSize: 12,
      fontFamily: 'Inter',
      color: Colors.white,
      fontWeight: fontWeight,
    );
  }

  Widget _buildQuickActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuickActionItem(
          iconPath: 'assets/icons/profile_page/ads.svg',
          label: "My\nAds",
          bgColor: const Color(0xFFE9F6FF),
          borderColor: const Color(0xFFD4EDFF),
          onTap: () => Get.toNamed(Routes.myAdsPage),
        ),
        _buildQuickActionItem(
          iconPath: 'assets/icons/profile_page/partners.svg',
          label: "My\nPartners",
          bgColor: const Color(0xFFFFFBF6),
          borderColor: const Color(0xFFFFEFDC),
          onTap: () => Get.to(() => const PartnersPage()),
        ),
        _buildQuickActionItem(
          iconPath: 'assets/icons/profile_page/payment.svg',
          label: "Payment\nMethods",
          bgColor: const Color(0xFFEAF9F0),
          borderColor: const Color(0xFFD5F4E2),
          onTap: () => Get.toNamed(Routes.paymentMethodsPage),
        ),
        // _buildQuickActionItem(
        //   iconPath: 'assets/icons/profile_page/headphone.svg',
        //   label: "Customer\nCare",
        //   bgColor: const Color(0xFFF4E9FE),
        //   borderColor: const Color(0xFFD8ABFC),
        //   onTap: () {},
        // ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
    required Color bgColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: SvgPicture.asset(iconPath, width: 40, height: 40),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF717F9A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCards(BuildContext context) {
    return Column(
      children: [
        ProfileGroupCard(
          children: [
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/kyc.svg',
              title: "KYC",
              subtitle: "Know Your Customer verification",
              onTap: () {
                Get.to(
                  () => UserKycInformationPage(),
                  binding: BindingsBuilder(() {
                    Get.put(UserKycInformationController());
                  }),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        ProfileGroupCard(
          children: [
            const Divider(height: 1, color: Color(0xFFF0F4FF)),
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/security.svg',
              title: "Account and Security",
              subtitle: "Manage your profile and settings",
              onTap: () => Get.to(() => AccountAndSecurityPage()),
            ),
            const Divider(height: 1, color: Color(0xFFF0F4FF)),
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/address.svg',
              title: "Address Book",
              subtitle: "Manage your saved addresses",
              onTap: () => Get.to(() => AddressBookPage()),
            ),

            const Divider(height: 1, color: Color(0xFFF0F4FF)),
          ],
        ),
        const SizedBox(height: 16),
        //Help and about us
        ProfileGroupCard(
          children: [
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/info_circle.svg',
              title: "Help Center ",
              subtitle: "Support, FAQs, and assistance",
              onTap: () => Get.toNamed(Routes.helpCenter),
            ),
            const Divider(height: 1, color: Color(0xFFF0F4FF)),
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/about.svg',
              title: "About us",
              subtitle: "Learn more about the app",
              onTap: () => Get.toNamed(Routes.aboutUs),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfileGroupCard(
          children: [
            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/setting.svg',
              title: "Settings",
              subtitle: "Account and application prefer",
              onTap: () => Get.toNamed(Routes.settings),
            ),
          ],
        ),
      ],
    );
  }
}
