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

class Routes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/HomeScreen'; 
  static const String accountSecurity = '/accountSecurity'; 
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
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
         Get.put(BalanceController()); 
      }),
    ),
    GetPage(
      name: Routes.accountSecurity,
      page: () => const AccountAndSecurityPage(),
    ),
  ];
}
