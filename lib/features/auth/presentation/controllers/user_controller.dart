import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    // Try account number first
    String? displayValue = await StorageService.getAccountNumber();

    // Fallback to login name
    if (displayValue == null || displayValue.isEmpty) {
      displayValue = await StorageService.getUserName();
    }

    if (displayValue != null && displayValue.isNotEmpty) {
      userName.value = displayValue;
    }
  }

  Future<void> setUserName(String name) async {
    userName.value = name;
    // Also ensuring storage is consistent if needed,
    // but primary source of truth for display is this reactive variable now.
  }
}
