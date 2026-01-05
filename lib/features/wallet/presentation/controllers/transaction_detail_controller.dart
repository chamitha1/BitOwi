import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/models/jour_front_detail.dart';
import 'package:BitOwi/models/withdraw_detail_res.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController {
  final isLoading = true.obs;
  final Rx<JourFrontDetail?> detail = Rx<JourFrontDetail?>(null);
  String? id;
  String? type; // '1': Deposit/Jour, '2': Withdraw

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'];
    type = Get.parameters['type'];

    if (id == null || id!.isEmpty) {
      final args = Get.arguments;
      if (args is Map) {
        id = args['id'];
        type = args['type'];
      }
    }

    if (id != null && id!.isNotEmpty) {
      fetchDetail();
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      if (type == '2') {
        if (id != null) {
          final res = await AccountApi.getWithdrawDetail(id!);
          print("Withdraw Details fetched: ${res.toJson()}"); 
          
        
          detail.value = JourFrontDetail(
            id: res.id,
            userId: res.userId,
            transAmount: (-(double.tryParse(res.actualAmount) ?? 0).abs()).toString(),
            currency: res.currency,
            status: res.status,
            createDatetime: res.createDatetime,
            remark: res.remark ?? res.payBank ?? 'Withdrawal', 
            accountNumber: res.payCardNo,
            refNo: res.id,
            bizType: '2',
            preAmount: '0',
            postAmount: '0',
          );
        }
      } else {
        if (id != null) {
          final res = await AccountApi.getJourDetail(id!);
          detail.value = res;
        }
      }
    } catch (e) {
      print("Error fetching transaction detail: $e");
      CustomSnackbar.showError(title: "Error", message: "Failed to load details");
    } finally {
      isLoading.value = false;
    }
  }
}
