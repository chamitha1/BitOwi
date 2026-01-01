import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildProfileCard(userController),
              const SizedBox(height: 24),
              _buildQuickActionsRow(),
              const SizedBox(height: 24),
              _buildMenuCards(),
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
                    return ClipOval(
                      child: (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? Image.network(avatarUrl, fit: BoxFit.cover)
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
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

  Widget _buildMenuCards() {
    return Column(
      children: [
        // Card 1
        _buildGroupCard([
          _buildMenuItem(
            iconPath: 'assets/icons/profile_page/security.svg',
            title: "Account and Security",
            subtitle: "Manage your profile and settings",
            onTap: () => Get.toNamed(Routes.accountSecurity),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4FF)),
        ]),
        const SizedBox(height: 16),
        // ... (other cards)
      ],
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            Color(0xFF1D5DE5),
            BlendMode.srcIn,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFF151E2F),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF6A7282),
        ),
      ),
      trailing: SvgPicture.asset(
        'assets/icons/profile_page/arrow-right.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Color(0xFF909DAD), BlendMode.srcIn),
      ),
    );
  }
}
