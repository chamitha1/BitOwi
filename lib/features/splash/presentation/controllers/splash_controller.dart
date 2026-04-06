import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/core/services/deep_link_service.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check 1: Has Completed Onboarding?
    bool hasCompletedOnboarding = await StorageService.hasCompletedOnboarding();
    if (!hasCompletedOnboarding) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    // Check 2: Remember Me & Token Validity
    bool isRememberMe = await StorageService.getRememberMe();
    String? token = await StorageService.getToken();

    if (isRememberMe && token != null && token.isNotEmpty) {
      // Check Token Expiry (7 days)
      bool isValid = await StorageService.isTokenValid();
      if (isValid) {
        // Refresh user data globally before entering Home
        await UserController.to.loadUser();

        await UserController.to.initIMForCurrentUser();

        await DeepLinkService.instance.routeAppOnLaunch();
        return;
      } else {
        // Token expired, clear it safely (optional but good practice)
        await StorageService.removeToken();
      }
    }

    // Fallback for everyone else (Old users, No Remember Me, Expired Token)
    Get.offAllNamed(Routes.login);
  }
}
