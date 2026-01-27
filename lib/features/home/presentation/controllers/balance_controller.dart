import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/account_detail_res.dart';
import 'package:BitOwi/models/account_asset_res.dart';
import 'package:BitOwi/models/account_detail_asset_inner_item.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';

class BalanceController extends GetxController {
  final Rx<AccountDetailAssetRes?> balanceData = Rx<AccountDetailAssetRes?>(
    null,
  );
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isObscured = false.obs;

  void toggleObscured() => isObscured.toggle();

  final RxString selectedCurrency = RxString('');

  AccountDetailAssetInnerItem? get selectedAsset {
    if (balanceData.value == null || selectedCurrency.value.isEmpty) {
      return null;
    }

    // Find the specific asset in the list
    try {
      return balanceData.value!.accountList.firstWhere(
        (element) => element.currency == selectedCurrency.value,
      );
    } catch (_) {
      return null;
    }
  }

  final Rx<AccountAssetRes?> homeAssetData = Rx<AccountAssetRes?>(null);

  final RxList<String> coinList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCoinList();
    fetchBalance();
  }

  Future<void> getCoinList() async {
    try {
      final result = await CommonApi.getDictList(
        parentKey: 'ads_trade_currency',
      );
      coinList.value = result.map((item) => item.key).toList();

      // Ensure current selected currency is valid/set
      final current = await StorageService.getCurrency();
      if (coinList.contains(current)) {
        selectedCurrency.value = current;
      } else if (coinList.isNotEmpty) {
        selectedCurrency.value = coinList.first;
      }
    } catch (e) {
      AppLogger.d("Error fetching coin list: $e");
    }
  }

  Future<void> fetchBalance() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final currency = await StorageService.getCurrency();
      selectedCurrency.value = currency;

      // Fetch both APIs concurrently
      await Future.wait([
        _fetchHomeAsset(currency),
        _fetchBalanceAccount(currency),
      ]);
    } catch (e) {
      AppLogger.d("BalanceController Error: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchHomeAsset(String currency) async {
    try {
      final res = await AccountApi.getHomeAsset(currency);
      homeAssetData.value = res;
      AppLogger.d("BalanceController: Fetched Home Asset for $currency");
    } catch (e) {
      AppLogger.d("Error fetching home asset: $e");
    }
  }

  Future<void> _fetchBalanceAccount(String currency) async {
    try {
      final res = await AccountApi.getBalanceAccount(assetCurrency: currency);
      AppLogger.d("BalanceController: Fetched Balance Account for $currency");
      balanceData.value = res;

      if (res.accountList.isNotEmpty) {
        final accNum = res.accountList.first.accountNumber;
        await StorageService.saveAccountNumber(accNum);
      }
    } catch (e) {
      AppLogger.d("Error fetching balance account: $e");
    }
  }

  Future<void> onChangeCurrency(String newCurrency) async {
    if (newCurrency == selectedCurrency.value) return;

    // 1. Update UI immediately
    selectedCurrency.value = newCurrency;

    // 2. Persist
    await StorageService.setCurrency(newCurrency);

    // 3. Refresh Data
    await fetchBalance();
  }

  void updateOptimisticBalance(String currency, double amountToMinus) {
    if (balanceData.value == null) return;

    final updatedList = balanceData.value!.accountList.map((item) {
      if (item.currency == currency) {
        final currentAmount = double.tryParse(item.usableAmount) ?? 0.0;
        final newAmount = currentAmount - amountToMinus;

        //  update totalAmount
        final currentTotal = double.tryParse(item.totalAmount) ?? 0.0;
        final newTotal = currentTotal - amountToMinus;

        return item.copyWith(
          usableAmount: newAmount.toStringAsFixed(8),
          totalAmount: newTotal.toStringAsFixed(8),
        );
      }
      return item;
    }).toList();

    balanceData.value = balanceData.value!.copyWith(accountList: updatedList);
  }
}
