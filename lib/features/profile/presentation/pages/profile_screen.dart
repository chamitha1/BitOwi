import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/features/address_book/presentation/pages/address_book_page.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/merchant/presentation/pages/user_kyc_information_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/change_transaction_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:BitOwi/features/profile/presentation/pages/account_security_page.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/user_kyc_personal_information_controller.dart';

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
              SizedBox(height: 56, child: _buildTopBar()),
              const SizedBox(height: 20),
              _buildProfileCard(userController),
              const SizedBox(height: 24),
              _buildQuickActionsRow(),
              const SizedBox(height: 24),
              _buildMenuCards(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
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
            // _buildCircleIconButton(
            //   icon: Icons.person_add_alt_1_outlined,
            //   onTap: () {},
            // ),
            // const SizedBox(width: 12),
            // _buildCircleIconButton(
            //   icon: Icons.notifications_none_outlined,
            //   onTap: () {},
            //   // badgeCount: 99,
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
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
            child: Icon(icon, size: 20, color: const Color(0xFF151E2F)),
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final avatarUrl = controller.user.value?.avatar;
                    return const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        "assets/images/home/avatar.png",
                      ),
                      backgroundColor: Color(0xffD9D9D9),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final name =
                            controller.user.value?.nickname ??
                            controller.userName.value;
                        return Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
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
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFC107),
                        BlendMode.srcIn,
                      ),
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

                Row(
                  children: [
                    Text(
                      "Trust ",
                      style: _statTextStyle(fontWeight: FontWeight.w400),
                    ),
                    Obx(
                      () => Text(
                        "${controller.tradeInfo.value?.confidenceCount ?? 0}",
                        style: _statTextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      "Trade ",
                      style: _statTextStyle(fontWeight: FontWeight.w400),
                    ),
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
        // ... (commented out code)
      ],
    );
  }

  // ... (existing _buildActionItem)

  Widget _buildMenuCards(BuildContext context) {
    return Column(
      children: [
        // Account and security and address book (kyc?)
        ProfileGroupCard(
          children: [
            ProfileMenuItem(
              iconPath: 'assets/icons/merchant_details/user_kyc.svg',
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
            // const Divider(height: 1, color: Color(0xFFF0F4FF)),

            // ProfileMenuItem(
            //   iconPath: 'assets/icons/profile_page/security.svg',
            //   title: "Change Transaction Password",
            //   subtitle: "",
            //   onTap: () => Get.to(() => const ChangeTransactionPasswordPage()),
            // ),
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
              onTap: () => Get.to(() => const ChangeTransactionPasswordPage()),
            ),
            const Divider(height: 1, color: Color(0xFFF0F4FF)),

            ProfileMenuItem(
              iconPath: 'assets/icons/profile_page/about.svg',
              title: "About us",
              subtitle: "Learn more about the app",
              onTap: () => Get.to(() => const ChangeTransactionPasswordPage()),
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
              onTap: () => Get.to(() => const ChangeTransactionPasswordPage()),
            ),
          ],
        ),
      ],
    );
  }
}
