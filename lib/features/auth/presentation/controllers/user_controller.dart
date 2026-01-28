import 'package:BitOwi/config/im_config.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/p2p/presentation/widgets/download_app_bottom_sheet.dart';
import 'package:BitOwi/features/profile/presentation/pages/chat.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/im_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/user_model.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

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

  Future<void> initIMForCurrentUser() async {
    final currentUser = user.value;

    if (currentUser == null) {
      throw Exception("User load failed after login");
    }
    // Init + Login IM (MOBILE ONLY)
    // if (PlatformUtils().isMobile) {
    //   if (!IMUtil.isInitSuccess) {
    //     await IMUtil.initIMSDKAndAddIMListeners(currentUser.id!);
    //   }
    //   if (!IMUtil.isLogin) {
    //     await IMUtil.loginIMUser(currentUser.id!);
    //   }
    // }
    if (!PlatformUtils().isMobile) return;

    await IMUtil.initIM(
      currentUser.id!,
      force: true, // 🔑 manual reconnect
    );
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
      await IMUtil.logoutIMUser();
      // Navigate to login
      Get.offAllNamed('/login');
    }
  }

  ///chat get customerServiceUserID

  String customerServiceUserID = ''; // Im customer service user id

  Future<void> getServiceUserID() async {
    try {
      final res = await CommonApi.getConfig(type: 'system', key: 'im_url');
      String value = res.data["im_url"] ?? '';
      customerServiceUserID = value;
    } catch (e) {
      AppLogger.d("Error getServiceUserID: $e");
    }
  }

  Future<void> customerServiceChatNavigate(BuildContext context) async {
    // 🔒 0️⃣ HARD BLOCK if IM was kicked
    if (IMUtil.imStatus == IMStatus.kicked) {
      Get.dialog(
        AlertDialog(
          title: const Text("Chat disconnected"),
          content: const Text(
            "Your chat session was logged out. Please reconnect.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Get.back();
                await UserController.to.initIMForCurrentUser();
              },
              child: const Text("Reconnect"),
            ),
          ],
        ),
      );
      return;
    }

    if (customerServiceUserID.isEmpty) {
      await getServiceUserID();
    }

    if (customerServiceUserID.isEmpty) {
      debugPrint('❌ customerServiceUserID still empty');
      CustomSnackbar.showError(
        title: "Error",
        message: "Customer Service Not Found",
      );
      return;
    }

    if (PlatformUtils().isMobile) {
      String conversationID = 'c2c_$customerServiceUserID';
      final res = await IMUtil.sdkInstance
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      debugPrint(' 💬 Conversation data Fetched ');
      if (res.code == 0) {
        final conversation = res.data;
        if (conversation != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                selectedConversation: conversation,
                customerServiceUserID: customerServiceUserID,
              ),
            ),
          );
        } else {
          debugPrint('Conversation is null');
        }
      } else {
        debugPrint('Failed to fetch conversation');
      }
    } else {
      // DownloadModal.showModal(context);
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const DownloadAppBottomSheet(),
      );
    }
  }
}
