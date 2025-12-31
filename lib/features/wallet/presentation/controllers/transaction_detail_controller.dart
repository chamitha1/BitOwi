import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/jour_front_detail.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController {
  final isLoading = true.obs;
  final Rx<JourFrontDetail?> detail = Rx<JourFrontDetail?>(null);
  String? id;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'];
    if (id != null && id!.isNotEmpty) {
      fetchDetail();
    } else {
      final args = Get.arguments;
      if (args is Map && args['id'] != null) {
        id = args['id'];
        fetchDetail();
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      final res = await AccountApi.getJourDetail(id!);
      detail.value = res;
    } catch (e) {
      print("Error fetching transaction detail: $e");
      Get.snackbar("Error", "Failed to load details");
    } finally {
      isLoading.value = false;
    }
  }
}
