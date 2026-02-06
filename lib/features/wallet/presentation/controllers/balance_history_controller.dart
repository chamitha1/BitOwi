import 'package:BitOwi/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/account_detail_res.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/models/account_detail_asset_inner_item.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:BitOwi/models/withdraw_page_res.dart';
import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';

class BalanceHistoryController extends GetxController {
  var currentTab = 0.obs;
  var isLoading = false.obs;
  var transactions = <Jour>[].obs;
  var accountDetail = Rxn<AccountDetailAssetRes>();

  int pageNum = 1;
  final int pageSize = 20;
  bool isEnd = false;

  String? accountNumber;
  String? symbol;

  var selectedCoin = "USDT".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    AppLogger.d("BalanceHistoryController onInit - Args: $args");
    if (args != null && args is Map) {
      accountNumber = args['accountNumber'];
      symbol = args['symbol'];
      if (symbol != null) {
        selectedCoin.value = symbol!;
      }
    }
    refreshData();
  }

  void changeTab(int index) {
    if (currentTab.value == index) return;
    AppLogger.d("Switching tab to $index");
    currentTab.value = index;
    refreshData();
  }

  void changeCoin(String coin) {
    if (selectedCoin.value == coin) return;
    AppLogger.d("Switching coin to $coin");
    selectedCoin.value = coin;

    // Update internal symbol/accountNumber if needed based on new coin
    // Find asset for new coin to correct account number if structure requires it
    // For now we assume refreshData relies on selectedCoin logic in _currentAssetItem
    // But transactions might need the correct account number for that coin?
    // Let's rely on finding the asset:

    if (accountDetail.value != null) {
      try {
        final item = accountDetail.value!.accountList.firstWhere(
          (e) => e.currency.toUpperCase() == coin.toUpperCase(),
        );
        accountNumber = item.accountNumber;
        symbol = item.currency;
      } catch (e) {
        AppLogger.d("Asset for $coin not found yet.");
      }
    }

    refreshData();
  }

  Future<void> refreshData() async {
    AppLogger.d("refreshData called. Coin: ${selectedCoin.value}");
    isLoading.value = true;
    pageNum = 1;
    isEnd = false;
    transactions.clear();

    try {
      await Future.wait([_fetchBalance(), _fetchTransactions()]);

      // Update local account/symbol refs if balance fetched new data
      if (accountDetail.value != null) {
        try {
          final item = accountDetail.value!.accountList.firstWhere(
            (e) => e.currency.toUpperCase() == selectedCoin.value.toUpperCase(),
          );
          accountNumber = item.accountNumber;
          symbol = item.currency;
        } catch (_) {}
      }
    } catch (e) {
      AppLogger.d("Error refreshing data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isEnd || isLoading.value) return;
    try {
      AppLogger.d("Loading more transactions. Page: ${pageNum + 1}");
      pageNum++;
      await _fetchTransactions();
    } catch (e) {
      AppLogger.d("Error loading more: $e");
      pageNum--;
    }
  }

  Future<void> _fetchBalance() async {
    try {
      AppLogger.d("Fetching balance (all assets)...");
      if (Get.isRegistered<BalanceController>()) {
        final mainController = Get.find<BalanceController>();
        if (mainController.balanceData.value != null) {
          AppLogger.d("Using BalanceController data (Optimistic)");
          accountDetail.value = mainController.balanceData.value;
          return;
        }
      }

      final res = await AccountApi.getBalanceAccount();
      AppLogger.d("Balance fetched successfully: ${res.totalAmount}");
      accountDetail.value = res;
    } catch (e) {
      AppLogger.d("Fetch balance error: $e");
    }
  }

  Future<void> _fetchTransactions() async {
    try {
      if (currentTab.value == 2) {
        // Withdraw Tab
        final Map<String, dynamic> params = {
          "pageNum": pageNum,
          "pageSize": pageSize,
        };
        if (accountNumber != null) {
          params['accountNumber'] = accountNumber;
        }
        AppLogger.d("Fetching Withdrawals with params: $params");

        final PageInfo<WithdrawPageRes> res =
            await AccountApi.getWithdrawPageList(params);
        AppLogger.d("Withdrawals fetched. Count: ${res.list.length}");

        final List<Jour> mappedList = res.list.map((w) {
          double amt = double.tryParse(w.actualAmount) ?? 0;
          if (amt > 0) amt = -amt;

          return Jour(
            id: w.id,
            userId: w.userId,
            bizType: '2',
            transAmount: amt.toString(),
            currency: w.currency,
            createDatetime: w.createDatetime,
            remark: "Withdraw",
            status: w.status,
          );
        }).toList();

        handleResponse(mappedList, res.isEnd);
      } else {
        // All (0) or Deposit (1)
        final Map<String, dynamic> params = {
          "pageNum": pageNum,
          "pageSize": pageSize,
          "bizCategory": '',
          "type": '0',
        };

        if (accountNumber != null) {
          params['accountNumber'] = accountNumber;
        }

        AppLogger.d(
          "Fetching Transactions (Tab: ${currentTab.value}) with params: $params",
        );

        final PageInfo<Jour> res = await AccountApi.getJourPageList(params);
        AppLogger.d("Jour fetched. Count: ${res.list.length}");

        List<Jour> processedList = res.list.map((item) {
          return item;
        }).toList();

        //Tab Filter
        if (currentTab.value == 1) {
          processedList = processedList.where((item) {
            final double amount = double.tryParse(item.transAmount ?? '0') ?? 0;
            return item.bizType == '1' || amount > 0;
          }).toList();
        }

        handleResponse(processedList, res.isEnd);
      }
    } catch (e) {
      AppLogger.d("Error fetching transactions: $e");
      rethrow;
    }
  }

  void handleResponse(List<Jour> fetchedList, bool end) {
    if (fetchedList.isEmpty && pageNum == 1) {
      isEnd = true;
    } else {
      if (pageNum == 1) {
        transactions.assignAll(fetchedList);
      } else {
        transactions.addAll(fetchedList);
      }
      if (end) {
        isEnd = true;
      }
    }
  }

  AccountDetailAssetInnerItem? get _currentAssetItem {
    if (accountDetail.value == null) return null;
    try {
      final item = accountDetail.value!.accountList.firstWhere(
        (e) => e.currency.toUpperCase() == selectedCoin.value.toUpperCase(),
        orElse: () => throw Exception("Not found"),
      );
      return item;
    } catch (e) {
      return null;
    }
  }

  String get totalBalance => _currentAssetItem?.totalAmount ?? "0.00";
  String get frozen => _currentAssetItem?.frozenAmount ?? "0.00";
  String get valuationUsdt => _currentAssetItem?.amountUsdt ?? "0.00";
  String get valuationOther => _currentAssetItem?.totalAsset ?? "0.00";
  String get iconUrl => _currentAssetItem?.icon ?? "";
}
