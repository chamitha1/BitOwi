import 'package:BitOwi/models/api_result.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/models/account_asset_res.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';

class BecomeMerchantController extends GetxController {
  /// 🔄 UI state
  final isLoading = false.obs;

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );

  /// 📦 Data
  final assetInfo = Rxn<AccountAssetRes>();
  final latestSubmittedInfo = Rxn<IdentifyOrderListRes>();

  double usdtAmount = 0;
  String frozenAmount = '';

  /// 🛡️ One-time UI side-effect guard
  bool hasShownMerchantSheet = false;

  /// 🔎 Computed values
  String get merchantStatus => assetInfo.value?.merchantStatus ?? '';
  // final merchantStatus = ''.obs;

  bool get hasEnoughAmount {
    if (merchantStatus == '0' ||
        merchantStatus == '1' ||
        merchantStatus == '3') {
      return true;
    }
    if (assetInfo.value == null || double.tryParse(frozenAmount) == null) {
      return false;
    }
    return usdtAmount >= double.parse(frozenAmount);
  }

  /// 🚀 Initial load
  @override
  void onInit() {
    super.onInit();
    getInitData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  /// 🔁 Init API calls
  Future<void> getInitData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        getLockAmount(),
        getHomeAsset(),
        getLatestIdentifyOrderList(),
        getUSDTAmount(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🏠 Asset
  Future<void> getHomeAsset() async {
    final res = await AccountApi.getHomeAsset();

    if (res.merchantStatus == '1') {
      final userId = await StorageService.getUserId();
      final isShowed = await StorageService.getMerchantSucTip(userId ?? '');
      hasShownMerchantSheet = isShowed; // UI will show once
      StorageService.setMerchantSucTip(userId ?? '');
    }

    assetInfo.value = res;
  }

  /// 🔒 Frozen amount
  Future<void> getLockAmount() async {
    final res = await CommonApi.getConfig(key: 'merchant_frozen_amount');
    frozenAmount = res.data["merchant_frozen_amount"] ?? '';
  }

  /// 💰 USDT
  Future<void> getUSDTAmount() async {
    final res = await AccountApi.getDetailAccount('USDT');
    usdtAmount = double.tryParse(res.availableAmount!) ?? 0;
  }

  /// 🧾 KYC
  Future<void> getLatestIdentifyOrderList() async {
    final list = await UserApi.getIdentifyOrderList();
    latestSubmittedInfo.value = list.isNotEmpty ? list.first : null;
  }

  /// 📝 Apply merchant
  Future<void> applyMerchant() async {
    try {
      isLoading.value = true;
      await UserApi.createMerchantOrder();
      await getHomeAsset();
    } finally {
      isLoading.value = false;
    }
  }

  /// ❌ Decertify
  Future<ApiResult> removeMerchant() async {
    return await UserApi.removeMerchantOrder();
  }

  /// 🔄 Refresh
  Future<void> refreshPage() async {
    isLoading.value = true;
    await getHomeAsset();
    await getLatestIdentifyOrderList();
    await getLockAmount();
    await getUSDTAmount();
    isLoading.value = false;
  }
}
