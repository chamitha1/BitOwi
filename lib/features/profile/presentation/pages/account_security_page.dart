import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/profile/presentation/pages/change_transaction_password_page.dart';
import 'package:BitOwi/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:BitOwi/features/profile/presentation/pages/add_authenticator_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/change_email_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/change_login_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AccountAndSecurityPage extends StatelessWidget {
  AccountAndSecurityPage({super.key});

  final RxBool isPatternLockEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF151E2F)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Account & Security",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Color(0XFF151E2F),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header Image
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF28A6FF), Color(0xFF1D5DE5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D5DE5).withOpacity(0.2),
                      offset: const Offset(0, 6),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/profile_page/account_security/shield-tick.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header Title
              const Text(
                "Account & Security",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(height: 8),
              // Header Subtitle
              const Text(
                "Manage Your Account Preferences",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  color: Color(0xFF717F9A),
                ),
              ),
              const SizedBox(height: 32),

              // Menu Items
              ProfileGroupCard(
                children: [
                  ProfileMenuItem(
                    iconPath:
                        'assets/icons/profile_page/account_security/arrow-swap-horizontal.svg',
                    title: "Change Transaction Password",
                    subtitle: "Update your transaction password",
                    onTap: () {
                      Get.to(() => const ChangeTransactionPasswordPage());
                    },
                  ),
                  const _Divider(),
                  ProfileMenuItem(
                    iconPath:
                        'assets/icons/profile_page/account_security/lock.svg',
                    title: "Change Login Password",
                    subtitle: "Transaction password, payment options",
                    onTap: () {
                      Get.to(() => const ChangeLoginPasswordPage());
                    },
                  ),
                  const _Divider(),
                  // Obx(() => ProfileMenuItem(
                  //   iconPath: 'assets/icons/profile_page/account_security/menu.svg',
                  //   title: "Pattern Lock",
                  //   subtitle: "Transaction password",
                  //   trailing: CupertinoSwitch(
                  //     value: isPatternLockEnabled.value,
                  //     activeColor: const Color(0xFF2ECC71),
                  //     onChanged: (value) {
                  //       isPatternLockEnabled.value = value;
                  //     },
                  //   ),
                  //   onTap: () {}, // Toggle switch
                  // )),
                  // const _Divider(),
                  ProfileMenuItem(
                    iconPath:
                        'assets/icons/profile_page/account_security/security-safe.svg',
                    title: "Authenticator App",
                    subtitle: "Enable 2 Factor Authentication",
                    onTap: () {
                      Get.to(() => const AddAuthenticatorPage());
                    },
                  ),
                  const _Divider(),
                  ProfileMenuItem(
                    iconPath:
                        'assets/icons/profile_page/account_security/sms-edit.svg',
                    title: "Change Email",
                    subtitle: "Update your email address",
                    onTap: () {
                      Get.to(() => const ChangeEmailPage());
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Log Out Button
              SizedBox(
                height: 56,
                width: double.infinity,
                child: TextButton(
                  onPressed: () => userController.logout(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF717F9A),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Delete Account Button
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _showDeleteConfirmDialog(context, userController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    UserController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Confirm Delete",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF151E2F),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Confirm if you want to delete account?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF454F63)),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(), // Close
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.logout(); // Reuse logout
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFF0F4FF));
  }
}
