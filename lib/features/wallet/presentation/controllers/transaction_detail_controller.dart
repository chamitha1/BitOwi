import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart'; // Added
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart'; // Added for Color
import 'package:BitOwi/models/jour_front_detail.dart';
import 'package:BitOwi/models/withdraw_detail_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController {
  final isLoading = true.obs;
  final Rx<JourFrontDetail?> detail = Rx<JourFrontDetail?>(null);
  String? id;
  String? type; // '1': Deposit/Jour, '2': Withdraw
  String? source; // 'ledger' State 1 | 'history' State 2

  var statusEnum = <String, String>{}.obs;

  bool get showFee => source == 'history';
  bool get showBalances => source == 'ledger';

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'];
    type = Get.parameters['type'];
    source = Get.parameters['source'] ?? 'ledger'; 

    if (id == null || id!.isEmpty) {
      final args = Get.arguments;
      if (args is Map) {
        id = args['id'];
        type = args['type'];
        source = args['source'] ?? 'ledger';
      }
    }

    if (id != null && id!.isNotEmpty) {
      fetchDetail();
    } else {
      isLoading.value = false;
    }
    fetchDict();
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

  String getStatusText(String? status) {
    if (status == null) return '';
    return statusEnum[status] ?? status;
  }

  Color getStatusColor(String? status) {
    if (status == '2' || status == '5') {
       return const Color(0xffFF5252);
    } else if (status == '6') {
       // Completed
       return const Color(0xff27AE60);
    } else {
       // Processing
       return const Color(0xFFEBA102);
    }
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      if (type == '2') {
        if (id != null) {
          final res = await AccountApi.getWithdrawDetail(id!);
          AppLogger.d("Withdraw Details fetched: ${res.toJson()}");

          double totalAmount = double.tryParse(res.amount) ?? 0;
          double actualAmount = double.tryParse(res.actualAmount) ?? 0;
          double feeVal = (totalAmount - actualAmount).abs();

          final rawTime = res.applyDatetime ?? res.createDatetime;
          int timestamp = 0;
          try {
            if (rawTime.isNotEmpty) {
              int? parsedInt = int.tryParse(rawTime);
              if (parsedInt != null) {
                if (parsedInt < 10000000000) {
                  timestamp = parsedInt * 1000;
                } else {
                  timestamp = parsedInt;
                }
              } else {
                DateTime? dt = DateTime.tryParse(rawTime);
                if (dt != null) timestamp = dt.millisecondsSinceEpoch;
              }
            }
          } catch (_) {}

          detail.value = JourFrontDetail(
            id: res.id,
            userId: res.userId,
            transAmount: (-(double.tryParse(res.actualAmount) ?? 0).abs())
                .toString(),
            currency: res.currency,
            status: res.status,
            createDatetime: timestamp,
            remark: res.remark ?? res.payBank ?? 'Withdrawal',
            accountNumber: res.payCardNo,
            refNo: res.id,
            bizType: '2',
            preAmount: '0',
            postAmount: '0',
            fee: feeVal.toStringAsFixed(2),
          );
        }
      } else {
        if (id != null) {
          final res = await AccountApi.getJourDetail(id!);
          detail.value = res;
        }
      }
    } on DioException catch (e) {
      AppLogger.d("API error: $e");
      final data = e.response?.data;
      final msg = (data is Map) ? (data['errorMsg'] ?? e.message) : e.message;
      CustomSnackbar.showError(title: "Error", message: msg ?? 'Unknown error');
    } catch (e) {
      AppLogger.d("Unexpected error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
        CustomSnackbar.showError(title: "Error", message: errorMsg);
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: 'Unexpected error occurred',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
