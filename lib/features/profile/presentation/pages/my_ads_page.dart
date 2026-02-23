import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_empty_state.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/confirm_dialog.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/models/ads_my_page_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:BitOwi/features/p2p/presentation/widgets/download_app_bottom_sheet.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  int selectedTab = 0; // 0: Draft, 1: Posted, 2: Archived

  late EasyRefreshController _controller;

  List<AdsMyPageRes> list = [];
  int pageNum = 1;
  bool isEnd = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    onRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      await getList(true);
      if (!mounted) {
        return;
      }
    } catch (e) {
      AppLogger.d("getMyAdsPageList onRefresh error: $e");
    }

    _controller.finishRefresh();
    _controller.resetFooter();
  }

  Future<void> onLoad() async {
    await getList();
    if (!mounted) {
      return;
    }
  }

  /// Get list from API based on selected tab
  Future<void> getList([bool isRefresh = false]) async {
    if (isLoading) return;
    try {
      setState(() {
        isLoading = true;
        if (isRefresh) {
          pageNum = 1;
        }
      });
      // Map tab index to status: 0=Draft, 1=Posted, 2=Archived
      final res = await C2CApi.getMyAdsPageList({
        "pageNum": pageNum,
        "pageSize": 10,
        "statusList": selectedTab == 0
            ? ['0']
            : selectedTab == 1
            ? ['1']
            : ['2'],
      });
      setState(() {
        isEnd = res.isEnd;
        if (isRefresh) {
          list = res.list;
        } else {
          list.addAll(res.list);
        }
        pageNum++;
      });
    } catch (e) {
      AppLogger.d("getMyAdsPageList getList error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get isEmpty {
    return isEnd && list.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "My Ads", onBack: () => Get.back()),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab("Draft", 0),
                const SizedBox(width: 12),
                _buildTab("Posted", 1),
                const SizedBox(width: 12),
                _buildTab("Archived", 2),
              ],
            ),
          ),
          // List Content with Pull-to-Refresh
          Expanded(
            child: EasyRefresh(
              controller: _controller,
              onRefresh: onRefresh,
              refreshOnStart: true,
              onLoad: onLoad,
              child: isLoading
                  ? SoftCircularLoader()
                  : isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      children: [
                        SizedBox(height: 50),
                        CommonEmptyState(
                          title: 'No Ads Available',
                          description:
                              'Post an ad to start trading with others.',
                          action: SizedBox(
                            width: 287,
                            child: PrimaryButton(
                              text: 'Post Ads',
                              onPressed: () async {
                                if (kIsWeb) {
                                  await showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (_) =>
                                        const DownloadAppBottomSheet(),
                                  );
                                } else {
                                  // final result = await Get.toNamed(
                                  //   Routes.postAdsPage,
                                  // );
                                  // // refresh after coming back
                                  // if (result == true) {
                                  //   // await _controller.callRefresh();
                                  //   onRefresh();
                                  // }

                                  final token = await StorageService.getToken();
                                  if (token != null) {
                                    if (Get.find<UserController>()
                                            .user
                                            .value
                                            ?.merchantStatus ==
                                        '1') {
                                      final result = await Get.toNamed(
                                        Routes.postAdsPage,
                                      );
                                      // refresh after coming back
                                      if (result == true) {
                                        // await _controller.callRefresh();
                                        onRefresh();
                                      }
                                    } else {
                                      // ToastUtil.showToast('您还未完成商家认证'.tr);
                                      CustomSnackbar.showWarning(
                                        title: 'Warning',
                                        message:
                                            'You have not completed merchant certification yet',
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      Get.toNamed(Routes.becomeMerchant);
                                    }
                                  } else {
                                    Get.toNamed(Routes.login);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _buildAdCard(ad: list[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedTab != index) {
            setState(() {
              selectedTab = index;
              list.clear();
              pageNum = 1;
              isEnd = false;
            });
            onRefresh(); // Fetch new data for selected tab
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFECEFF5),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: AppText.p2Bold(
            title,
            color: isSelected ? Colors.white : const Color(0xFF8F9BB3),
          ),
        ),
      ),
    );
  }

  Widget _buildAdCard({required AdsMyPageRes ad}) {
    final userController = Get.find<UserController>();

    // Calculate completion rate from userStatistics
    final stats = ad.userStatistics;
    final finishRate = stats.orderCount > 0
        ? ((stats.orderFinishCount / stats.orderCount) * 100).toStringAsFixed(1)
        : "0.0";

    // Payment type display
    final payTypeDisplay = ad.bankPic != null
        ? ad.bankName ?? 'Bank Transfer'
        : 'Bank Transfer';

    // Buy or Sell
    final isBuy = ad.tradeType == "0";

    // Bank or Mobile card
    final hasBank = ad.bankPic != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* User Info Row
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFECEFF5).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: () {
                        // Get.toNamed(
                        //   Routes.paymentMethodsPage,
                        //   parameters: {"userId": info.userId},
                        // );
                        debugPrint(" Navigate to userCenter merchant ads");
                      },

                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Routes.merchantProfilePage,
                            arguments: ad.userId,
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: ClipOval(
                                child: ad.photo.isNotEmpty
                                    ? CommonImage(
                                        ad.photo,
                                        fit: BoxFit.cover,
                                        height: 32,
                                        width: 32,
                                      )
                                    : Container(
                                        color: const Color(0xFFE8EFFF),
                                        alignment: Alignment.center,
                                        child: Text(
                                          _getInitials(ad.nickname),
                                          style: const TextStyle(
                                            color: Color(0xFF1D5DE5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Nickname
                            AppText.p2SemiBold(ad.nickname),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    // Certified
                    if (userController.user.value?.merchantStatus == '1')
                      Container(
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

                            AppText.p4Medium(
                              'Certified',
                              color: Color(0xFF1D5DE5),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                //* Stats Row
                Row(
                  children: [
                    // completion rate
                    // SvgPicture.asset(
                    //   'assets/icons/profile_page/like.svg',
                    //   width: 16,
                    //   height: 16,
                    //   colorFilter: const ColorFilter.mode(
                    //     Colors.orange,
                    //     BlendMode.srcIn,
                    //   ),
                    // ),
                    // const SizedBox(width: 6),
                    // AppText.p4Regular("$finishRate%", color: Color(0xFF717F9A)),
                    // Container(
                    //   height: 17,
                    //   width: 1,
                    //   margin: const EdgeInsets.symmetric(horizontal: 6),
                    //   color: Color(0xFFB9C6E2),
                    // ),
                    // Trust
                    AppText.p4Regular("Trust", color: Color(0xFF717F9A)),
                    AppText.p4SemiBold(
                      '  ${ad.userStatistics.confidenceCount}',
                      color: Color(0xFF717F9A),
                    ),
                    Container(
                      height: 17,
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: Color(0xFFB9C6E2),
                    ),
                    // Trade
                    AppText.p4Regular("Trade", color: Color(0xFF717F9A)),
                    AppText.p4SemiBold(
                      '  ${ad.userStatistics.orderCount} /  $finishRate%',
                      color: Color(0xFF717F9A),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          //* True Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${CommonUtils.getUnit(ad.tradeCurrency)} ${ad.truePrice}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF151E2F),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy
                      ? const Color(0xFFEAF9F0)
                      : const Color(0xFFFDF4F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isBuy
                          ? 'assets/icons/profile_page/arrow_down_left.svg'
                          : 'assets/icons/profile_page/arrow_up_right.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    AppText.p4Medium(
                      isBuy ? 'Buy Ad' : 'Sell Ad',
                      color: isBuy
                          ? const Color(0xFF40A372)
                          : const Color(0xFFE74C3C),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info Rows (Total & Limit)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Row
                    Row(
                      children: [
                        AppText.p3Regular(
                          "Total: ",
                          color: const Color(0xFF929EB8),
                        ),
                        AppText.p3Medium("${ad.leftCount} ${ad.tradeCoin}"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Limit Row
                    Row(
                      children: [
                        AppText.p3Regular(
                          "Limit: ",
                          color: const Color(0xFF929EB8),
                        ),
                        Expanded(
                          child: AppText.p3Medium(
                            "${CommonUtils.getUnit(ad.tradeCurrency)}${ad.minTrade}–${CommonUtils.getUnit(ad.tradeCurrency)}${ad.maxTrade}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (selectedTab == 0) ...[
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Post Button
                    ElevatedButton.icon(
                      onPressed: () => onPostTap(ad),
                      icon: SvgPicture.asset(
                        'assets/icons/profile_page/post.svg',
                        width: 16,
                        height: 16,
                      ),
                      label: AppText.p3Medium('Post', color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D5DE5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(90, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Edit Button
                    OutlinedButton.icon(
                      onPressed: () => onEditTap(ad),
                      icon: SvgPicture.asset(
                        'assets/icons/profile_page/edit.svg',
                        width: 16,
                        height: 16,
                      ),
                      label: AppText.p3Medium(
                        'Edit',
                        color: const Color(0xFF1D5DE5),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1D5DE5),
                        side: const BorderSide(color: Color(0xFF1D5DE5)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(90, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ] else if (selectedTab == 1) ...[
                const SizedBox(width: 8),
                // Off Button
                ElevatedButton.icon(
                  onPressed: () => offDownTap(ad),
                  icon: SvgPicture.asset(
                    'assets/icons/profile_page/toggle_off_circle.svg',
                    width: 16,
                    height: 16,
                  ),
                  label: AppText.p3Medium('Off', color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(90, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          const Divider(color: Color(0xFFECEFF5), height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasBank
                      ? const Color(0xFFFDF4F5)
                      : const Color(0xFFFFFBF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText.p4Medium(
                  payTypeDisplay,
                  color: hasBank
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFFFF9B29),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Post ad (Draft → Posted)
  void onPostTap(AdsMyPageRes ad) async {
    if (kIsWeb) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const DownloadAppBottomSheet(),
      );
    } else {
      AppLogger.d("Post ad: ${ad.id}");

      showCommonConfirmDialog(
        context,
        title: "Post This Ad?",
        message:
            "Once posted, this ad will be visible to other users and open for trading.",
        primaryText: "Confirm",
        secondaryText: "Cancel",
        onPrimary: () async {
          if (isLoading) return;

          setState(() {
            isLoading = true;
          });

          try {
            await C2CApi.upDownAds(ad.id, "1"); // 1 = on shelf

            setState(() {
              list.removeWhere((e) => e.id == ad.id);
            });

            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Ad posted successfully",
            );
          } catch (e) {
            debugPrint("Post ad error: $e");

            CustomSnackbar.showError(
              title: "Error",
              message: "Something went wrong",
            );
          } finally {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        onSecondary: () {
          debugPrint("User cancelled post ad");
        },
      );
    }
  }

  // Archive ad (Posted → Archived)
  void offDownTap(AdsMyPageRes ad) async {
    if (kIsWeb) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const DownloadAppBottomSheet(),
      );
    } else {
      AppLogger.d("Turn off ad: ${ad.id}");

      showCommonConfirmDialog(
        context,
        title: "Confirmation to Off",
        message:
            "This ad will be moved to Archived and will no longer be visible to other users. Once archived, this action cannot be undone",
        primaryText: "Confirm",
        secondaryText: "Cancel",
        onPrimary: () async {
          if (isLoading) return;
          setState(() {
            isLoading = true;
          });

          try {
            await C2CApi.upDownAds(ad.id, "0");
            setState(() {
              list.removeWhere((e) => e.id == ad.id);
            });
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Ad turned off successfully",
            );
          } catch (e) {
            debugPrint("Off ad error: $e");
            CustomSnackbar.showError(
              title: "Error",
              message: "Something went wrong",
            );
          } finally {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        onSecondary: () {
          debugPrint("User cancelled off ad");
        },
      );
    }
  }

  void onEditTap(AdsMyPageRes ad) async {
    if (kIsWeb) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const DownloadAppBottomSheet(),
      );
      return;
    }
    AppLogger.d(" Navigate to edit ad page / Edit ad: ${ad.id}");
    final result = await Get.toNamed(
      Routes.postAdsPage,
      parameters: {'id': ad.id},
    );

    // refresh after coming back
    if (result == true) {
      // await _controller.callRefresh();
      onRefresh();
    }
  }
}
