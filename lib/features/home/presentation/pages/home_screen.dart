import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/home_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/merchant_banner.dart';
import '../widgets/balance_section.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../../../../features/profile/presentation/pages/profile_screen.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import '../../../../features/p2p/presentation/pages/p2p_page.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalanceController controller = Get.put(BalanceController());

  int _navIndex = 0;

  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(controlFinishRefresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      await controller.fetchBalance();
    } catch (e) {
      print(e);
    }
    _refreshController.finishRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
      body: SafeArea(
        child: EasyRefresh(
          controller: _refreshController,
          onRefresh: onRefresh,
          child: IndexedStack(
            index: _navIndex,
            children: [
              // Index 0: Home
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 56, child: const HomeHeader()),
                    const SizedBox(height: 20),
                    const WalletCard(),
                    const SizedBox(height: 20),
                    /* merchantStatus
                    -1 = blue
                    0 = yellow
                    1 = green
                    2 = blue
                    3 = ---- yellow ---- wont come anymore
                    4 = blue
                    */
                    Obx(() {
                      final status =
                          controller.homeAssetData.value?.merchantStatus ?? '';
                      return MerchantBanner(merchantStatus: status);
                    }),
                    // const SizedBox(height: 24),
                    // const TabSection(),
                    const SizedBox(height: 24),
                    const BalanceSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Index 1: P2P
              const P2PPage(),
              // Index 2: Order (Placeholder)
              const P2PPage(),
              // Index 3: Profile
              const ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() => _navIndex = index);
          if (index == 3) {
            // Profile index
            Get.find<UserController>().fetchNotificationCount();
          }
        },
      ),
    );
  }
}
