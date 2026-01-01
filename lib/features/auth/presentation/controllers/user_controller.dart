import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:get/get.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/user_model.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final userName = 'User'.obs;
  // Expose full user object
  final Rx<User?> user = Rx<User?>(null);

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
    return ((tradeInfo.value!.commentGoodCount / tradeInfo.value!.commentCount) *
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

      // Fetch Trade Info if user is loaded
      if (fetchedUser.id != null) {
        getTradeInfo(fetchedUser.id!);
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> getTradeInfo(String userId) async {
    try {
      print("Fetching C2C Ads Info for master: $userId");
      final res = await C2CApi.getOtherUserAdsHome(userId);
      tradeInfo.value = res;
      print("Trade Info Fetched: OrderCount=${res.orderCount}, FinishCount=${res.orderFinishCount}");
      print("Calculated Good Rate: $goodRate");
      print("Calculated Finish Rate: $finishRate");
      print("Trade Info Fetched: OrderCount=$res");
    } catch (e) {
      print("Error fetching trade info: $e");
    }
  }

  Future<void> setUserName(String name) async {
    userName.value = name;
  }

  Future<void> logout() async {
    try {
      await UserApi.logOff();
    } catch (e) {
      print("Logout API failed: $e");
    } finally {
      // Clear data regardless of API success
      await StorageService.removeToken();
      // Navigate to login
      Get.offAllNamed('/login');
    }
  }
}
