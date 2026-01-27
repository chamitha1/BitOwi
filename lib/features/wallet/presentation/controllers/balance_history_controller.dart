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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    AppLogger.d("BalanceHistoryController onInit - Args: $args");
    if (args != null && args is Map) {
      accountNumber = args['accountNumber'];
      symbol = args['symbol'];
    }
    refreshData();
  }

  void changeTab(int index) {
    if (currentTab.value == index) return;
    AppLogger.d("Switching tab to $index");
    currentTab.value = index;
    refreshData();
  }

  Future<void> refreshData() async {
    AppLogger.d(
      "refreshData called. Symbol: $symbol, AccountNumber: $accountNumber",
    );
    isLoading.value = true;
    pageNum = 1;
    isEnd = false;
    transactions.clear();

    try {
      await Future.wait([_fetchBalance(), _fetchTransactions()]);
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
          /*
              String finalBizType = item.bizType ?? '';
              final double amount = double.tryParse(item.transAmount ?? '0') ?? 0;

              if (finalBizType != '1' && finalBizType != '2') {
                 if (amount < 0) {
                   finalBizType = '2'; // Withdraw
                 } else {
                   finalBizType = '1'; // Deposit
                 }
              }
              return item.copyWith(bizType: finalBizType);
              */

          // Just return item as is, or ensure bizType is NOT '2' unless it really is a withdrawal ID source.
          // Since this is getJourPageList, these are always Journal IDs.
          // We force '1' (or just leave it) to ensure getJourDetail is used.

          return item;
        }).toList();

        //Tab Filter
        if (currentTab.value == 1) {
          processedList = processedList.where((item) {
            final double amount = double.tryParse(item.transAmount ?? '0') ?? 0;
            return item.bizType == '1' || amount > 0;
          }).toList();
        }

        //Tab 0 shows everything from getJourPageList

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
    if (accountDetail.value == null) {
      AppLogger.d("DEBUG: accountDetail.value is null");
      return null;
    }
    if (symbol == null) {
      AppLogger.d("DEBUG: symbol is null in getter");
      return null;
    }
    try {
      final item = accountDetail.value!.accountList.firstWhere(
        (e) => e.currency.toUpperCase() == symbol!.toUpperCase(),
        orElse: () {
          AppLogger.d(
            "DEBUG: Asset not found for symbol: $symbol. Available: ${accountDetail.value!.accountList.map((e) => e.currency).toList()}",
          );
          throw Exception("Not found");
        },
      );
      return item;
    } catch (e) {
      if (e.toString() != "Exception: Not found") {
        AppLogger.d("DEBUG: Error finding asset: $e");
      }
      return null;
    }
  }

  String get totalBalance => _currentAssetItem?.totalAmount ?? "0.00";
  String get frozen => _currentAssetItem?.frozenAmount ?? "0.00";
  String get valuationUsdt => _currentAssetItem?.amountUsdt ?? "0.00";

  String get valuationOther => _currentAssetItem?.totalAsset ?? "0.00";
}
