import 'package:BitOwi/features/merchant/presentation/controllers/become_merchant_controller.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/user_kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/pages/become_merchant_page.dart';
import 'package:BitOwi/features/merchant/presentation/pages/personal_information_page.dart';
import 'package:BitOwi/features/merchant/presentation/pages/user_kyc_information_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/help_center.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/auth/presentation/pages/login_screen.dart';
import 'package:BitOwi/features/auth/presentation/pages/signup_screen.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:BitOwi/features/splash/presentation/pages/splash_screen.dart';
import 'package:BitOwi/features/splash/presentation/controllers/splash_controller.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/features/profile/presentation/pages/account_security_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/transaction_detail_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/wallet_detail_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/deposit_screen.dart';
import 'package:BitOwi/features/wallet/presentation/pages/withdraw_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/HomeScreen';
  static const String accountSecurity = '/accountSecurity';
  static const String transactionDetail = '/transactionDetail';
  static const String walletDetail = '/walletDetail';
  static const String deposit = '/deposit';
  static const String withdrawal = '/withdrawal';
  //
  static const String becomeMerchant = '/becomeMerchant';
  static const String kycPersonalInformation = '/kycPersonalInformation';
  static const String userKycPersonalInformation =
      '/userKycPersonalInformation';
  static const String helpCenter = '/helpCenter';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(name: Routes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.signup, page: () => const SignupScreen()),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(BalanceController());
      }),
    ),
    //
    GetPage(
      name: Routes.becomeMerchant,
      page: () => BecomeMerchantPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BecomeMerchantController>(() => BecomeMerchantController());
      }),
    ),
    GetPage(
      name: Routes.kycPersonalInformation,
      page: () => KycPersonalInformationPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<KycPersonalInformationController>(
          () => KycPersonalInformationController(),
        );
      }),
    ),
    GetPage(
      name: Routes.userKycPersonalInformation,
      page: () => UserKycInformationPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserKycInformationController>(
          () => UserKycInformationController(),
        );
      }),
    ),
    //
    GetPage(name: Routes.accountSecurity, page: () => AccountAndSecurityPage()),
    GetPage(
      name: Routes.transactionDetail,
      page: () => const TransactionDetailPage(),
    ),
    GetPage(name: Routes.walletDetail, page: () => const WalletDetailPage()),
    GetPage(name: Routes.deposit, page: () => const DepositScreen()),
    GetPage(
      name: Routes.withdrawal,
      page: () {
        final args = Get.arguments ?? {};
        return WithdrawScreen(
          symbol: Get.parameters['symbol'] ?? args['symbol'] ?? '',
          accountNumber:
              Get.parameters['accountNumber'] ?? args['accountNumber'] ?? '',
        );
      },
    ),
    GetPage(name: Routes.helpCenter, page: () => HelpCenter()),
  ];
}
