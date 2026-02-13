import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/models/account_detail_account_and_jour_res.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:get/get.dart';

class WalletDetailController extends GetxController {
  var isLoading = true.obs;
  var accountInfo = Rxn<AccountDetailAccountAndJourRes>();
  var transactionList = <Jour>[].obs;

  // Pagination
  int pageNum = 1;
  var isEnd = false.obs;
  var isLoadMore = false.obs;
  var currentTab = 0.obs;

  String symbol = '';
  String accountNumber = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      symbol = args['symbol'] ?? '';
      accountNumber = args['accountNumber'] ?? '';
    } else {
      symbol = Get.parameters['symbol'] ?? '';
      accountNumber = Get.parameters['accountNumber'] ?? '';
    }

    if (accountNumber.isEmpty) {
      // Fallback or error?
      AppLogger.d("WalletDetailController: accountNumber is empty!");
    }
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  Future<void> refreshData() async {
    try {
      if (symbol.isEmpty || accountNumber.isEmpty) return;

      if (accountInfo.value == null) {
        isLoading.value = true;
      }
      // isLoading.value = transactionList.isEmpty; // Show global loading only on init

      // Fetch Account Detail

      final detailRes = await AccountApi.getDetailAccountAndJour(
        accountNumber,
        symbol,
      );
      accountInfo.value = detailRes;

      // Refresh List
      pageNum = 1;
      isEnd.value = false;
      await fetchTransactionList(isRefresh: true);
    } catch (e) {
      AppLogger.d("Error refreshing wallet detail: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionList({bool isRefresh = false}) async {
    if (!isRefresh && isEnd.value) return;
    try {
      if (!isRefresh) isLoadMore.value = true;
      if (!isRefresh) isLoadMore.value = true;

      // Use Journal API for ALL tabs to ensure we get Journal IDs (for Balances)
      final params = {
        "accountNumber": accountNumber,
        "pageNum": pageNum,
        "pageSize": 10,
        "bizCategory": '',
        "type": "0", // Default All
      };

      final res = await AccountApi.getJourPageList(params);
      List<Jour> processedList = res.list;

      // Tab Filter:
      // 0: All
      // 1: Deposits (bizType '1' or amount > 0)
      // 2: Withdrawals (bizType '2' or amount < 0)
      if (currentTab.value == 1) {
        processedList = processedList.where((item) {
          final double amount = double.tryParse(item.transAmount ?? '0') ?? 0;
          return item.bizType == '1' || amount > 0;
        }).toList();
      } else if (currentTab.value == 2) {
         processedList = processedList.where((item) {
          final double amount = double.tryParse(item.transAmount ?? '0') ?? 0;
          return item.bizType == '2' || amount < 0; // Filter for withdrawals
        }).toList();
      }

      if (isRefresh) {
        transactionList.value = processedList;
      } else {
        transactionList.addAll(processedList);
      }
      isEnd.value = res.isEnd;

      if (!isEnd.value) pageNum++;
    } catch (e) {
      AppLogger.d("Error fetching transaction list: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void loadMore() {
    fetchTransactionList();
  }

  void changeTab(int index) {
    if (currentTab.value == index) return;
    currentTab.value = index;
    // Reset list and reload
    pageNum = 1;
    isEnd.value = false;
    transactionList.clear();
    fetchTransactionList(isRefresh: true);
  }
}
