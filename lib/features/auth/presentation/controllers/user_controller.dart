import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/user_model.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final userName = 'User'.obs;
  // Expose full user object
  final Rx<User?> user = Rx<User?>(null);
  final RxInt notificationCount = 0.obs;

  final RxString userAvatar = ''.obs;
  final RxString userRealName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  final Rx<AdsHomeRes?> tradeInfo = Rx<AdsHomeRes?>(null);

  String get goodRate {
    if (tradeInfo.value == null) return '0';
    if (tradeInfo.value!.commentCount == 0) {
      return '0';
    }
    return ((tradeInfo.value!.commentGoodCount /
                tradeInfo.value!.commentCount) *
            100)
        .toStringAsFixed(1);
  }

  String get finishRate {
    if (tradeInfo.value == null) return '0';
    if (tradeInfo.value!.orderCount == 0) {
      return '0';
    }
    return ((tradeInfo.value!.orderFinishCount / tradeInfo.value!.orderCount) *
            100)
        .toStringAsFixed(1);
  }

  Future<void> loadUser() async {
    // Fetch latest user info from API
    try {
      final fetchedUser = await UserApi.getUserInfo();
      user.value = fetchedUser;

      if (fetchedUser.nickname != null && fetchedUser.nickname!.isNotEmpty) {
        setUserName(fetchedUser.nickname!);
      } else if (fetchedUser.realName != null &&
          fetchedUser.realName!.isNotEmpty) {
        setUserName(fetchedUser.realName!);
      }

      if (fetchedUser.avatar != null && fetchedUser.avatar!.isNotEmpty) {
        setUserAvatar(fetchedUser.avatar!);
      } else {
        setUserAvatar('');
      }

      if (fetchedUser.realName != null && fetchedUser.realName!.isNotEmpty) {
        setRealName(fetchedUser.realName!);
      } else {
        setRealName('');
      }

      // Fetch Trade Info if user is loaded
      if (fetchedUser.id != null) {
        getTradeInfo(fetchedUser.id!);
      }
    } catch (e) {
      AppLogger.d('Error fetching user info: $e');
    }
  }

  Future<void> getTradeInfo(String userId) async {
    try {
      AppLogger.d("Fetching C2C Ads Info for master: $userId");
      final res = await C2CApi.getOtherUserAdsHome(userId);
      tradeInfo.value = res;
      AppLogger.d(
        "Trade Info Fetched: OrderCount=${res.orderCount}, FinishCount=${res.orderFinishCount}",
      );
      AppLogger.d("Calculated Good Rate: $goodRate");
      AppLogger.d("Calculated Finish Rate: $finishRate");
      AppLogger.d("Trade Info Fetched: OrderCount=$res");
    } catch (e) {
      AppLogger.d("Error fetching trade info: $e");
    }
  }

  Future<void> setUserName(String name) async {
    userName.value = name;
  }

  Future<void> setUserAvatar(String avatarUrl) async {
    userAvatar.value = avatarUrl;
  }

  Future<void> setRealName(String realName) async {
    userRealName.value = realName;
  }

  Future<void> fetchNotificationCount() async {
    try {
      AppLogger.d("Fetching notification count...");
      final results = await Future.wait([
        CommonApi.getSmsPageByType(
          pageNum: 1,
          pageSize: 100, // Fetch 100 items to count locally
          type: "1", // Announcements
        ),
        CommonApi.getSmsPageByType(
          pageNum: 1,
          pageSize: 100,
          type: "2", // Notifications
        ),
      ]);

      int unreadCount = 0;

      for (var res in results) {
        if (res['code'] == 200 || res['code'] == '200') {
          final data = res['data'];
          if (data != null && data['list'] != null) {
            final List list = data['list'];
            // Count items where isRead is '0'
            final count = list
                .where((item) => item['isRead'].toString() == '0')
                .length;
            unreadCount += count;
          }
        }
      }

      notificationCount.value = unreadCount;
      AppLogger.d("Notification count updated: ${notificationCount.value}");
    } catch (e) {
      AppLogger.d("Error fetching notification count: $e");
    }
  }

  Future<void> logout() async {
    try {
      await UserApi.logOff();
    } catch (e) {
      AppLogger.d("Logout API failed: $e");
    } finally {
      // Clear data regardless of API success
      await StorageService.removeToken();
      // Navigate to login
      Get.offAllNamed('/login');
    }
  }
}
