import 'package:BitOwi/features/merchant/presentation/controllers/become_merchant_controller.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/user_kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/pages/become_merchant_page.dart';
import 'package:BitOwi/features/merchant/presentation/pages/personal_information_page.dart';
import 'package:BitOwi/features/merchant/presentation/pages/user_kyc_information_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/about_us.dart';
import 'package:BitOwi/features/profile/presentation/pages/add_bank_card_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/add_mobile_money_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/change_nickname.dart';
import 'package:BitOwi/features/profile/presentation/pages/help_center.dart';
import 'package:BitOwi/features/profile/presentation/pages/local_currency.dart';
import 'package:BitOwi/features/profile/presentation/pages/me_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/my_ads_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/post_ads_page.dart';
import 'package:BitOwi/features/profile/presentation/pages/settings.dart';
import 'package:get/get.dart';
import 'package:BitOwi/features/auth/presentation/pages/login_screen.dart';
import 'package:BitOwi/features/auth/presentation/pages/signup_screen.dart';
import 'package:BitOwi/features/home/presentation/pages/home_screen.dart';
import 'package:BitOwi/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:BitOwi/features/splash/presentation/pages/splash_screen.dart';
import 'package:BitOwi/features/splash/presentation/controllers/splash_controller.dart';
import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/features/profile/presentation/pages/account_security_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/transaction_detail_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/wallet_detail_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/deposit_screen.dart';
import 'package:BitOwi/features/wallet/presentation/pages/withdraw_screen.dart';
import 'package:BitOwi/features/orders/presentation/pages/order_details_page.dart';

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
  //
  static const String helpCenter = '/helpCenter';
  static const String aboutUs = '/aboutUs';
  static const String settings = '/settings';
  static const String mePage = '/mePage';
  static const String changeNickname = '/changeNickname';
  static const String localCurrency = '/localCurrency';
  //
  static const String paymentMethodsPage = '/paymentMethods';
  static const String addBankCardPage = '/addBankCardPage';
  static const String addMobileMoneyPage = '/addMobileMoneyPage';
  static const String postAdsPage = '/postAdsPage';
  static const String myAdsPage = '/myAdsPage';
  static const String orderDetailPage = '/orderDetail';
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
    GetPage(name: Routes.aboutUs, page: () => AboutUs()),
    GetPage(name: Routes.settings, page: () => Settings()),
    GetPage(name: Routes.mePage, page: () => MePage()),
    GetPage(name: Routes.changeNickname, page: () => ChangeNickname()),
    GetPage(name: Routes.localCurrency, page: () => LocalCurrency()),
    //
    GetPage(name: Routes.paymentMethodsPage, page: () => PaymentMethodsPage()),
    GetPage(name: Routes.addBankCardPage, page: () => AddBankCardPage()),
    GetPage(name: Routes.addMobileMoneyPage, page: () => AddMobileMoneyPage()),
    GetPage(name: Routes.postAdsPage, page: () =>PostAdsPage()),
    GetPage(name: Routes.myAdsPage, page: () => MyAdsPage()),
    GetPage(
      name: Routes.orderDetailPage,
      page: () {
        final orderId = Get.parameters['orderId'] ?? '';
        return OrderDetailsPage(orderId: orderId);
      },
    ),

  ];
}
