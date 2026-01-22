import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/features/p2p/presentation/widgets/p2p_order_card.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MerchantProfilePage extends StatefulWidget {
  const MerchantProfilePage({super.key});

  @override
  State<MerchantProfilePage> createState() => _MerchantProfilePageState();
}

class _MerchantProfilePageState extends State<MerchantProfilePage> {
  late String userId;
  UserStatistics? merchantInfo;
  List<AdItem> adsList = [];
  int pageNum = 1;
  bool isEnd = false;
  bool isLoading = false;
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    userId = Get.arguments as String;
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    getInitData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> getInitData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch merchant profile stats
      final stats = await P2PApi.getMerchantHome(userId);

      if (mounted) {
        setState(() {
          merchantInfo = stats;
        });
      }

      // Fetch first page of ads
      await getAdsList(isRefresh: true);
    } catch (e) {
      debugPrint("getInitData Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Trust Toggle
  Future<void> onTrustTap() async {
    if (merchantInfo == null) return;

    try {
      if (merchantInfo!.isTrust == '1') {
        await UserApi.removeUserRelation(toUser: userId, type: '1');
        if (mounted) {
          setState(() {
            merchantInfo!.isTrust = '0';
          });
        }
      } else {
        await UserApi.createUserRelation(toUser: userId, type: '1');
        if (mounted) {
          setState(() {
            merchantInfo!.isTrust = '1';
            merchantInfo!.isAddBlackList = '0';
          });
        }
      }
    } catch (e) {
      debugPrint("Trust action failed: $e");
      //  Get.snackbar("Error", "Failed to update trust status");
    }
  }

  //  Blacklist Toggle
  Future<void> onBlacklistTap() async {
    if (merchantInfo == null) return;

    try {
      if (merchantInfo!.isAddBlackList == '1') {
        await UserApi.removeUserRelation(toUser: userId, type: '0');
        if (mounted) {
          setState(() {
            merchantInfo!.isAddBlackList = '0';
          });
        }
      } else {
        await UserApi.createUserRelation(toUser: userId, type: '0');
        if (mounted) {
          setState(() {
            merchantInfo!.isAddBlackList = '1';
            merchantInfo!.isTrust = '0';
          });
        }
      }
    } catch (e) {
      debugPrint("Blacklist action failed: $e");
    }
  }

  Future<void> getAdsList({bool isRefresh = false}) async {
    if (isRefresh) {
      pageNum = 1;
      isEnd = false;
    } else if (isEnd) {
      return;
    }

    try {
      final res = await P2PApi.getMerchantAdsList({
        "pageNum": pageNum,
        "pageSize": 10,
        "userId": userId,
      });

      if (mounted) {
        setState(() {
          if (isRefresh) {
            adsList = res.list ?? [];
          } else {
            adsList.addAll(res.list ?? []);
          }
          isEnd = (res.list ?? []).isEmpty || (res.list?.length ?? 0) < 10;
          pageNum++;
        });
      }

      _refreshController.finishRefresh();
      _refreshController.finishLoad();
    } catch (e) {
      debugPrint("getAdsList Error: $e");
      _refreshController.finishRefresh();
      _refreshController.finishLoad();
    }
  }

  String _calculatePositiveRate() {
    if (merchantInfo == null ||
        merchantInfo!.commentCount == null ||
        merchantInfo!.commentCount == 0) {
      return '0.0';
    }
    final rate =
        (merchantInfo!.commentGoodCount ?? 0) /
        merchantInfo!.commentCount! *
        100;
    return rate.toStringAsFixed(1);
  }

  String _calculateCompletionRate() {
    if (merchantInfo == null ||
        merchantInfo!.orderCount == null ||
        merchantInfo!.orderCount == 0) {
      return '0.0';
    }
    final rate =
        (merchantInfo!.orderFinishCount ?? 0) / merchantInfo!.orderCount! * 100;
    return rate.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Merchant Profile",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF151E2F),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : EasyRefresh(
              controller: _refreshController,
              onRefresh: () async => await getAdsList(isRefresh: true),
              onLoad: () async => await getAdsList(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    const Text(
                      "Merchant Ads",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF151E2F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF779DEF), width: 3),
                ),
                child: ClipOval(
                  child: merchantInfo?.photo != null
                      ? CommonImage(merchantInfo!.photo!, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/images/home/avatar.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantInfo?.nickname ?? "Merchant",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (merchantInfo?.isTrust == '1') ...[
                      const SizedBox(height: 4),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
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
                    Text(
                      "${_calculatePositiveRate()}%",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
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
                    const Text(
                      "Trust ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${merchantInfo?.confidenceCount ?? 0}",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
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
                    const Text(
                      "Trade ",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${merchantInfo?.orderFinishCount ?? 0} / ${_calculateCompletionRate()}%",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  iconPath: 'assets/icons/profile_page/tick-square.svg',
                  label: merchantInfo?.isTrust == '1'
                      ? "Remove Trust"
                      : "Trust",
                  onTap: onTrustTap,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  iconPath: 'assets/icons/profile_page/card-send.svg',
                  label: merchantInfo?.isAddBlackList == '1'
                      ? "Remove Blacklist"
                      : "Blacklist",

                  onTap: onBlacklistTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1D5DE5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x331D5DE5),
              offset: Offset(0, 6),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 20, height: 20),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdList() {
    if (adsList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            "No ads available",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF717F9A),
            ),
          ),
        ),
      );
    }

    return Column(
      children: adsList.map((ad) {
        final isBuy = ad.tradeType == '0'; // 0 = buy, 1 = sell
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: P2POrderCard(adItem: ad, isBuy: isBuy),
        );
      }).toList(),
    );
  }
}
