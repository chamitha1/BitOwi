import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:BitOwi/models/withdraw_page_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
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
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    AppLogger.d("TransactionHistoryController onInit - Args: $args");
    if (args != null && args is Map) {
      accountNumber = args['accountNumber'];
      symbol = args['symbol'];
    }
    if (accountNumber == null && symbol != null) {
      final account = await AccountApi.getDetailAccount(symbol!);
      accountNumber = account.accountNumber;
    }

    if (args.containsKey('isDeposit')) {
      isDeposit.value = args['isDeposit'];
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
      AppLogger.d("Error fetching dict: $e");
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
        "pageNum": pageNum,
        "pageSize": pageSize,
        "type": "0",
        "bizCategory": "",
      };

      if (accountNumber != null) {
        params['accountNumber'] = accountNumber;
      }

      final res = await AccountApi.getJourPageList(params);

      final deposits = res.list.where((item) {
        final amt =
            double.tryParse(item.transAmount?.replaceAll(',', '') ?? '0') ?? 0;
        return amt > 0;
      }).toList();

      if (deposits.isEmpty && res.list.isEmpty) {
        isEnd.value = true;
      } else {
        if (refresh) {
          depositList.assignAll(deposits);
        } else {
          depositList.addAll(deposits);
        }

        if (res.list.length < pageSize) {
          isEnd.value = true;
        }
      }
    } catch (e) {
      AppLogger.d("Fetch deposits error: $e");
      if (!refresh) pageNum--;
    }
  }

  Future<void> fetchWithdrawals({bool refresh = false}) async {
    try {
      final Map<String, dynamic> params = {
        "pageNum": pageNum,
        "pageSize": pageSize,
      };

      if (symbol != null) {
        params['currency'] = symbol;
      }
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
      AppLogger.d("Fetch withdrawals error: $e");
      if (!refresh) pageNum--;
    }
  }
}
