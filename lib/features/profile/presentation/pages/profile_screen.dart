import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
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
                          : const Icon(Icons.person,
                              size: 40, color: Colors.white), 
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
                        final name = controller.user.value?.nickname ??
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
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_user,
                                size: 14, color: Color(0xFF1D5DE5)),
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
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                   children: [
                     const Icon(Icons.thumb_up_alt, size: 14, color: Color(0xFFFFC107)), 
                     const SizedBox(width: 4),
                     Text("99.0%", style: _statTextStyle(fontWeight: FontWeight.w400)),
                   ],
                 ),
                 
                 Row(
                   children: [
                     Text("Trust ", style: _statTextStyle(fontWeight: FontWeight.w400)),
                     Text("453,657", style: _statTextStyle(fontWeight: FontWeight.w600)),
                   ],
                 ),
                 
                 Row(
                   children: [
                     Text("Trade ", style: _statTextStyle(fontWeight: FontWeight.w400)),
                      Text("453,657 / 99.9%", style: _statTextStyle(fontWeight: FontWeight.w600)),
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
        // _buildActionItem(
        //   label: "My\nAds",
        //   icon: Icons.campaign_outlined,
        //   bgColor: const Color(0xFFE9F6FF),
        //   borderColor: const Color(0xFFD4EDFF),
        // ),
        // _buildActionItem(
        //   label: "My\nPartners", 
        //   icon: Icons.people_outline,
        //   bgColor: const Color(0xFFFFFBF6),
        //   borderColor: const Color(0xFFFFEFDC),
        // ),
        // _buildActionItem(
        //   label: "Payment\nMethods",
        //   icon: Icons.credit_card_outlined,
        //   bgColor: const Color(0xFFEAF9F0),
        //   borderColor: const Color(0xFFD5F4E2),
        // ),
        // _buildActionItem(
        //   label: "Customer\nCare",
        //   icon: Icons.headset_mic_outlined,
        //   bgColor: const Color(0xFFF4E9FE),
        //   borderColor: const Color(0xFFD8ABFC),
        // ),
      ],
    );
  }

  Widget _buildActionItem({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Column(
      children: [
        Container(
          width: 56, 
          height: 56,
          decoration: BoxDecoration(
             color: bgColor,
             borderRadius: BorderRadius.circular(16),
             border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: const Color(0xFF151E2F), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label.replaceAll('\n', ' '), 
          textAlign: TextAlign.center,
          style: const TextStyle(
             fontSize: 12,
             fontFamily: 'Inter',
             fontWeight: FontWeight.w500,
             color: Color(0xFF717F9A),
             height: 1.2
          ),
        )
      ],
    );
  }

  Widget _buildMenuCards() {
    return Column(
      children: [
        // Card 1
        _buildGroupCard([
          _buildMenuItem(
            icon: Icons.security,
            title: "Account and Security",
            subtitle: "Manage your profile and settings",
            onTap: () => Get.toNamed(Routes.accountSecurity),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4FF)),
          // _buildMenuItem(
          //   icon: Icons.book_outlined,
          //   title: "Address Book",
          //   subtitle: "Manage your saved addresses",
          //   onTap: () {},
          // ),
        ]),
        const SizedBox(height: 16),
        // Card 2
        // _buildGroupCard([
        //    _buildMenuItem(
        //     icon: Icons.info_outline,
        //     title: "Help Center",
        //     subtitle: "Support, FAQs, and assistance",
        //     onTap: () {},
        //   ),
        //   const Divider(height: 1, color: Color(0xFFF0F4FF)),
        //    _buildMenuItem(
        //     icon: Icons.smartphone_outlined,
        //     title: "About us",
        //     subtitle: "Learn more about the app",
        //     onTap: () {},
        //   ),
        // ]),
        const SizedBox(height: 16),
        // Card 3
        // _buildGroupCard([
        //    _buildMenuItem(
        //     icon: Icons.settings_outlined,
        //     title: "Settings",
        //     subtitle: "Account and application preferences",
        //     onTap: () {},
        //   ),
        // ]),
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
    required IconData icon,
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
        child: Icon(icon, color: const Color(0xFF1D5DE5), size: 20),
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
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF909DAD)),
    );
  }
}

