import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/core/widgets/custom_loader.dart';
import 'package:BitOwi/features/orders/presentation/controllers/orders_controller.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/home_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/merchant_banner.dart';
import '../widgets/balance_section.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../../../../features/profile/presentation/pages/profile_screen.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import '../../../../features/p2p/presentation/pages/p2p_page.dart';
import 'package:BitOwi/features/orders/presentation/pages/orders_page.dart';
import 'package:BitOwi/core/services/deep_link_service.dart';
import 'package:BitOwi/features/home/presentation/controllers/home_popup_controller.dart';
import 'package:BitOwi/features/home/presentation/widgets/home_dynamic_popup.dart';
import 'package:BitOwi/models/common_dynamic_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalanceController controller = Get.put(BalanceController());
  final HomePopupController popupController = Get.put(HomePopupController());

  int _navIndex = 0;
  DateTime? _lastPressedAt;

  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(controlFinishRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await popupController.loadHomePopups();
      await _showNextPopup();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      if (_navIndex == 0) {
        // Home Tab
        await controller.fetchBalance();
        await popupController.loadHomePopups(force: true);
        await _showNextPopup();
      } else if (_navIndex == 3) {
        // Profile Tab
        final userController = Get.find<UserController>();
        await userController.loadUser();
        await userController.fetchNotificationCount();
      }
    } catch (e) {
      AppLogger.e(e);
    }
    _refreshController.finishRefresh();
  }


  Future<void> _showNextPopup() async {
    if (!mounted || _navIndex != 0 || popupController.isShowingPopup.value) {
      return;
    }

    final popup = popupController.nextPopup();
    if (popup == null) return;

    popupController.isShowingPopup.value = true;
    await popupController.markHandled(popup);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => HomeDynamicPopup(
        popup: popup,
        onClose: () => Navigator.of(context).pop(),
        onTap: () async {
          Navigator.of(context).pop();
          await _handlePopupTap(popup);
        },
      ),
    );

    popupController.isShowingPopup.value = false;
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _showNextPopup();
  }

  Future<void> _handlePopupTap(CommonDynamicPopup popup) async {
    final url = (popup.url ?? '').trim();
    if (url.isEmpty) return;

    switch (popup.action) {
      case 0:
        if (url.startsWith('/')) {
          Get.toNamed(url);
          return;
        }
        final uri = Uri.tryParse(url);
        if (uri == null) return;
        if (uri.hasScheme &&
            (uri.scheme == 'bitowi' || uri.scheme == 'http' || uri.scheme == 'https')) {
          await DeepLinkService.instance.handleIncomingLink(
            uri,
            isLoggedIn: true,
          );
          return;
        }
        return;
      case 1:
      case 2:
        final uri = Uri.tryParse(url);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        return;
      case 3:
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2); // 2-second window
        final isWarningActive =
            _lastPressedAt != null &&
            now.difference(_lastPressedAt!) < maxDuration;

        if (isWarningActive) {
          //  Second tap: actually close the app
          await SystemNavigator.pop();
        } else {
          // First tap: update time and show warning
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0XFFF6F9FF),
        body: SafeArea(
          child: EasyRefresh(
            header: BuilderHeader(
              position: IndicatorPosition.above,
              triggerOffset: 60,
              clamping: false,
              builder: (context, state) {
                if (state.offset == 0) return const SizedBox.shrink();
                return Container(
                  height: state.offset,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CustomLoader(width: 50, height: 50),
                );
              },
            ),
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
                            controller.homeAssetData.value?.merchantStatus ??
                            '';
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
                // Index 2: Order
                const OrdersPage(),
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
            if (index == 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _showNextPopup();
              });
            }
            if (index == 3) {
              // Profile index
              Get.find<UserController>().fetchNotificationCount();
            }
            if (index == 2) {
              // Order index
              if (kIsWeb) return;
              Get.find<OrdersController>().orderItemUnreadConvoLoad();
            }
          },
        ),
      ),
    );
  }
}
