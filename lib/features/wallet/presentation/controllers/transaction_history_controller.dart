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
    depositList.clear();
    withdrawList.clear(); 
    if (isDeposit.value) {
      await fetchTransactions(type: '1'); // Deposits
    } else {
      await fetchTransactions(type: '2'); // Withdrawals
    }
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isEnd.value || isLoading.value) return;
    isLoading.value = true;
    pageNum++;
    await fetchTransactions(type: isDeposit.value ? '1' : '2');
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
        final processedList = res.list.map((item) {
          final rawTime = item.applyDatetime ?? item.createDatetime;
          String fixedTime = item.createDatetime; // Default fallback
          String calculatedFee = "0.00";

          try {
            double total = double.tryParse(item.amount) ?? 0;
            double actual = double.tryParse(item.actualAmount) ?? 0;
            double diff = (total - actual).abs();
            calculatedFee = diff.toStringAsFixed(2);
          } catch (_) {}

          try {
            if (rawTime != null) {
              // Check if numeric
              int? parsedInt = int.tryParse(rawTime);
              if (parsedInt != null) {
                if (parsedInt < 10000000000) {
                  fixedTime = (parsedInt * 1000).toString();
                } else {
                  fixedTime = parsedInt.toString();
                }
              } else {
                // Check if Date String
                DateTime? dt = DateTime.tryParse(rawTime);
                if (dt != null) {
                  fixedTime = dt.millisecondsSinceEpoch.toString();
                }
              }
            }
          } catch (_) {}
          return WithdrawPageRes(
            id: item.id,
            userId: item.userId,
            amount: item.amount,
            actualAmount: item.actualAmount,
            fee: calculatedFee,
            currency: item.currency,
            status: item.status,
            createDatetime:
                fixedTime, 
            payDatetime: item.payDatetime,
            applyDatetime: item.applyDatetime,
            payCardNo: item.payCardNo,
            payCardName: item.payCardName,
            payBank: item.payBank,
          );
        }).toList();
        if (refresh) {
          withdrawList.assignAll(processedList);
        } else {
          withdrawList.addAll(processedList);
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

  Future<void> fetchTransactions({required String type}) async {
    try {
      final Map<String, dynamic> params = {
        "pageNum": pageNum,
        "pageSize": pageSize,
        "bizCategory": '',
        "type": '0',
      };
      if (accountNumber != null) {
        params['accountNumber'] = accountNumber;
      }
      final res = await AccountApi.getJourPageList(params);
      List<Jour> filteredList = res.list;
      if (type == '1') {
        // Deposits (Positive Amount or BizType 1)
        filteredList = filteredList.where((item) {
          double amt = double.tryParse(item.transAmount ?? '0') ?? 0;
          return item.bizType == '1' || amt > 0;
        }).toList();
      } else {
        // Withdrawals (Negative Amount or BizType 2)
        filteredList = filteredList.where((item) {
          double amt = double.tryParse(item.transAmount ?? '0') ?? 0;
          return item.bizType == '2' || amt < 0;
        }).toList();
      }
      if (res.list.isEmpty && filteredList.isEmpty) {
        isEnd.value = true;
      } else {
        if (pageNum == 1) {
          depositList.assignAll(filteredList);
        } else {
          depositList.addAll(filteredList);
        }
        if (res.list.length < pageSize) {
          isEnd.value = true;
        }
      }
    } catch (e) {
      AppLogger.d("Fetch error: $e");
      if (pageNum > 1) pageNum--;
    }
  }
}
