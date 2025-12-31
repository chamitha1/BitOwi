import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/models/account_asset_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/merchant_banner.dart';
import '../widgets/tab_section.dart';
import '../widgets/balance_section.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../../../../features/profile/presentation/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  AccountAssetRes? assetInfo;

  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(controlFinishRefresh: true);

    getInitData();
  }

  Future<void> getInitData() async {
    // final isLogin = context.read<AuthProvider>().isLogin;
    // if (isLogin) {
    // await getCoinList();
    await getHomeAsset();
    // getAccountList();
    // }
  }

  Future<void> getHomeAsset() async {
    try {
      String currency = await StorageService.getCurrency();
      final res = await AccountApi.getHomeAsset(currency);
      assetInfo = res;
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      // final futures = [getBannerList()];
      // final isLogin = context.read<AuthProvider>().isLogin;
      // if (isLogin) {
      // futures.add(getHomeAsset());
      await getHomeAsset();
      // }
      // await Future.wait<void>(futures);
      // if (isLogin) {
      //   await getAccountList();
      // }
    } catch (e) {
      print(e);
    }
    _controller.finishRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final merchantStatus = assetInfo?.merchantStatus ?? '';

    // MerchantStatus status = MerchantStatus.notApplied;

    return Scaffold(
      backgroundColor: const Color(0XFFF6F9FF),
      body: SafeArea(
        child: EasyRefresh(
          controller: _controller,
          onRefresh: onRefresh,
          child: IndexedStack(
          index: _navIndex,
          children: [
            // Index 0: Home
            SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeHeader(),
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
                MerchantBanner(merchantStatus: merchantStatus),
                    const SizedBox(height: 24),
                    // const TabSection(),
                    const SizedBox(height: 24),
                    const BalanceSection(),
                    const SizedBox(height: 20),
                  ],
                ),
            ),
             // Index 1: P2P (Placeholder)
            const Center(child: Text("P2P Page")),
            // Index 2: Order (Placeholder)
            const Center(child: Text("Order Page")),
             // Index 3: Profile
            const ProfileScreen(),
          ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),
    );
  }
}
