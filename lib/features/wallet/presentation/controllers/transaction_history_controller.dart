import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/models/withdraw_page_res.dart';
import 'package:get/get.dart';

class TransactionHistoryController extends GetxController {
  var isDeposit = true.obs;

  // Lists
  var depositList = <Jour>[].obs;
  var withdrawList = <WithdrawPageRes>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isEnd = false.obs;

  // Pars
  int pageNum = 1;
  final int pageSize = 10;

  String? accountNumber;
  String? symbol;

  // Status Dictionary
  var statusEnum = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print("TransactionHistoryController onInit - Args: $args");
    if (args != null && args is Map) {
      accountNumber = args['accountNumber'];
      symbol = args['symbol'];
    }

    // Fetch Dictionary for status mapping
    fetchDict();

    // Initial Fetch
    refreshData();
  }

  void changeTab(bool deposit) {
    if (isDeposit.value == deposit) return;
    isDeposit.value = deposit;
    refreshData();
  }

  Future<void> fetchDict() async {
    try {
      final res = await CommonApi.getDictList(parentKey: 'withdraw.status');
      for (var element in res) {
        statusEnum[element.key] = element.value;
      }
    } catch (e) {
      print("Error fetching dict: $e");
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    pageNum = 1;
    isEnd.value = false;

    // Clear list for current tab to show loading or empty state
    if (isDeposit.value) {
      depositList.clear();
      await fetchDeposits(refresh: true);
    } else {
      withdrawList.clear();
      await fetchWithdrawals(refresh: true);
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isEnd.value || isLoading.value) return;

    isLoading.value = true;
    pageNum++;

    if (isDeposit.value) {
      await fetchDeposits();
    } else {
      await fetchWithdrawals();
    }

    isLoading.value = false;
  }

  Future<void> fetchDeposits({bool refresh = false}) async {
    try {
      final Map<String, dynamic> params = {
        "pageNum": pageNum,
        "pageSize": pageSize,
        // "bizType": "1",
      };

      if (accountNumber != null) {
        params['accountNumber'] = accountNumber;
      }

      final res = await AccountApi.getJourPageList(params);

      if (res.list.isEmpty) {
        isEnd.value = true;
      } else {
        if (refresh) {
          depositList.assignAll(res.list);
        } else {
          depositList.addAll(res.list);
        }

        if (res.list.length < pageSize) {
          isEnd.value = true;
        }
      }
    } catch (e) {
      print("Fetch deposits error: $e");
      if (!refresh) pageNum--;
    }
  }

  Future<void> fetchWithdrawals({bool refresh = false}) async {
    try {
      final Map<String, dynamic> params = {
        "pageNum": pageNum,
        "pageSize": pageSize,
      };

      final res = await AccountApi.getWithdrawPageList(params);

      if (res.list.isEmpty) {
        isEnd.value = true;
      } else {
        if (refresh) {
          withdrawList.assignAll(res.list);
        } else {
          withdrawList.addAll(res.list);
        }

        if (res.list.length < pageSize) {
          isEnd.value = true;
        }
      }
    } catch (e) {
      print("Fetch withdrawals error: $e");
      if (!refresh) pageNum--;
    }
  }
}
